/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.SQLException;
import java.util.Date;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.commons.validator.EmailValidator;
import org.dspace.app.webui.util.AvaliacaoBDjurEnum;
import org.dspace.app.webui.util.AvaliacaoGrauDificuldadeEnum;
import org.dspace.app.webui.util.FrequenciaConteudoUteisEnum;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.TipoUsuarioEnum;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.Email;
import org.dspace.core.I18nUtil;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;

/**
 * Servlet for handling user feedback
 *
 * @author Peter Breton
 * @author Robert Tansley
 * @version $Revision$
 */
public class FeedbackServlet extends DSpaceServlet
{
    /** log4j category */
    private static Logger log = Logger.getLogger(FeedbackServlet.class);

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // Obtain information from request
        // The page where the user came from
        String fromPage = request.getHeader("Referer");

        // Prevent spammers and splogbots from poisoning the feedback page
        String host = ConfigurationManager.getProperty("dspace.hostname");

        String basicHost = "";
        if (host.equals("localhost") || host.equals("127.0.0.1")
        		|| host.equals(InetAddress.getLocalHost().getHostAddress()))
        {
            basicHost = host;
        }
        else
        {
            // cut off all but the hostname, to cover cases where more than one URL
            // arrives at the installation; e.g. presence or absence of "www"
            int lastDot = host.lastIndexOf('.');
            basicHost = host.substring(host.substring(0, lastDot).lastIndexOf("."));
        }

//        if (fromPage == null || fromPage.indexOf(basicHost) == -1)
//        {
//            throw new AuthorizeException();
//        }

        // The email address they provided
        String formEmail = obterEmailNosParametros(request);
        if(formEmail.equals("")) {
        	formEmail = "emailPadrao@gmail.com";
        }

        // Browser
        String userAgent = request.getHeader("User-Agent");

        // Session id
        String sessionID = request.getSession().getId();

        // User email from context
        EPerson currentUser = context.getCurrentUser();
        String authEmail = null;

        if (currentUser != null)
        {
            authEmail = currentUser.getEmail();
        }

        // Has the user just posted their feedback?
        if (request.getParameter("submit") != null)
        {
            EmailValidator ev = EmailValidator.getInstance();
            String feedback = obterCorpoEmail(request).toString();

            // Check all data is there
            if ((formEmail == null) || formEmail.equals("")
                    || (feedback == null) || feedback.equals("") || !ev.isValid(formEmail))
            {
                log.info(LogManager.getHeader(context, "show_feedback_form",
                        "problem=true"));
                request.setAttribute("feedback.problem", Boolean.TRUE);
                JSPManager.showJSP(request, response, "/feedback/form.jsp");

                return;
            }

            // All data is there, send the email
            try
            {
                Email email = Email.getEmail(I18nUtil.getEmailFilename(context.getCurrentLocale(), "feedback"));
                email.addRecipient(ConfigurationManager
                        .getProperty("feedback.recipient"));

                email.addArgument(new Date()); // Date
                email.addArgument(formEmail); // Email
                email.addArgument(authEmail); // Logged in as
                email.addArgument(fromPage); // Referring page
                email.addArgument(userAgent); // User agent
                email.addArgument(sessionID); // Session ID
                email.addArgument(feedback); // The feedback itself

                // Replying to feedback will reply to email on form
                email.setReplyTo(formEmail);

                email.send();

                log.info(LogManager.getHeader(context, "sent_feedback", "from="
                        + formEmail));

                JSPManager.showJSP(request, response,
                        "/feedback/acknowledge.jsp");
            }
            catch (MessagingException me)
            {
                log.warn(LogManager.getHeader(context,
                        "error_mailing_feedback", ""), me);

                JSPManager.showInternalError(request, response);
            }
        }
        else
        {
            log.info(LogManager.getHeader(context, "show_feedback_form",
                    "problem=false"));
            request.setAttribute("authenticated.email", authEmail);
            JSPManager.showJSP(request, response, "/feedback/form.jsp");
        }
    }
    
	private StringBuilder obterCorpoEmail(HttpServletRequest request) {
		StringBuilder s = new StringBuilder();
		s.append(!isNuloOuVazio(request.getParameter("identificacaoNome")) ? "Nome : "+ request.getParameter("identificacaoNome")+" \n" : "") ;
		s.append(obterEmailNosParametros(request)) ;
		s.append(!isNuloOuVazio(request.getParameter("tipoUsuario")) ? "Tipo de usuário : "+ TipoUsuarioEnum.obterLabelPorString(request.getParameter("tipoUsuario"))+" \n" : "");
		s.append(!isNuloOuVazio(request.getParameter("encontrouConteudo")) ? "Você encontrou os conteúdos pesquisados? : "+ (request.getParameter("encontrouConteudo").equals("n") ? "Não. Quais? "+request.getParameter("descricaoNaoEncontrouConteudo") + "\n" : request.getParameter("encontrouConteudo").equals("s") ? "Sim \n" : "")  : "");
		s.append(!isNuloOuVazio(request.getParameter("utilidadeUteis")) ? "Com que frequência os conteúdos recuperados são úteis para a sua pesquisa? : "+ FrequenciaConteudoUteisEnum.obterLabelPorString(request.getParameter("utilidadeUteis"))+" \n" : "");
		s.append(!isNuloOuVazio(request.getParameter("grauDificuldade")) ? "Como você avalia o grau de dificuldade da pesquisa? : "+ AvaliacaoGrauDificuldadeEnum.obterLabelPorString(request.getParameter("grauDificuldade"))+" \n" : "");
		s.append(!isNuloOuVazio(request.getParameter("avaliacaoBdjur")) ? "De modo geral, como você avalia a BDJur? : "+ AvaliacaoBDjurEnum.obterLabelPorString(request.getParameter("avaliacaoBdjur"))+" \n" : "");
		s.append(!isNuloOuVazio(request.getParameter("opinioesBDJur")) ? "Deixe suas opiniões sobre a BDJur : "+ request.getParameter("opinioesBDJur")+" \n" : "") ;
		return s;
	}
	
	private Boolean isNuloOuVazio(Object s) {
		if(s == null || s.equals("")) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	private String obterEmailNosParametros(HttpServletRequest request) {
		return !isNuloOuVazio(request.getParameter("identificacaoEmail")) ? "E-mail : "+ request.getParameter("identificacaoEmail")+" \n" : "";
	}

    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // Treat as a GET
        doDSGet(context, request, response);
    }
}
