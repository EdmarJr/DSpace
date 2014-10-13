<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Feedback form JSP
  -
  - Attributes:
  -    feedback.problem  - if present, report that all fields weren't filled out
  -    authenticated.email - email of authenticated user, if any
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    boolean problem = (request.getParameter("feedback.problem") != null);
    String email = request.getParameter("email");

    if (email == null || email.equals(""))
    {
        email = (String) request.getAttribute("authenticated.email");
    }

    if (email == null)
    {
        email = "";
    }

    String feedback = request.getParameter("feedback");
    if (feedback == null)
    {
        feedback = "";
    }

    String fromPage = request.getParameter("fromPage");
    if (fromPage == null)
    {
		fromPage = "";
    }
%>

<dspace:layout titlekey="jsp.feedback.form.title">
    <%-- <h1>Feedback Form</h1> --%>
    <h1><fmt:message key="jsp.feedback.form.title"/></h1>

    <%-- <p>Thanks for taking the time to share your feedback about the
    DSpace system. Your comments are appreciated!</p> --%>
    <p><fmt:message key="jsp.feedback.form.text1"/></p>

<%
    if (problem)
    {
%>
        <%-- <p><strong>Please fill out all of the information below.</strong></p> --%>
        <p><strong><fmt:message key="jsp.feedback.form.text2"/></strong></p>
<%
    }
%>
    <form action="<%= request.getContextPath() %>/feedback" method="post">
        <div class="col-lg-12">
       	<h4> Identificação (opcional)</h4>
       	<div class="col-lg-12">
	        <div class="input-group">
				<span class="input-group-addon">Nome</span> <input type="text" class="form-control" placeholder="Digite seu nome completo" name="identificacaoNome">
			</div>
			
			<div class="input-group">
				<span class="input-group-addon">E-mail</span> <input type="text" class="form-control" placeholder="Digite seu endereço de e-mail" name="identificacaoEmail">
			</div>
  		</div>
	       	
       	<h4> Tipo de usuário</h4>
       	<div class="col-lg-12">
       	<ul class="list-group">
				<li class="list-group-item">
					<span> <input id="tipoUsuario" value="i" name="tipoUsuario" type="radio" >
						<span >Usuário interno</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="tipoUsuario" value="e" name="tipoUsuario" type="radio" >
						<span >Usuário externo</span>
					</span>
				</li>
				
			</ul>
	 	</div>
	 	<h4> Você encontrou os conteúdos pesquisados?</h4>
       	<div class="col-lg-12">
       	
  			 	<ul class="list-group">
				<li class="list-group-item">
					<span> <input id="encontrouConteudo" value="s" name="encontrouConteudo" type="radio" >
						<span >Sim</span>
					</span>
				</li>
				<li class="list-group-item">
					
			        	<span><input id="encontrouConteudo" value="n" name="encontrouConteudo" type="radio" >Não. Quais?
				      	<input type="text" name="descricaoNaoEncontrouConteudo" class="form-control"></span>
			      	
				</li>
			</ul>
  			 
       	</div>
        	
       	<h4> Com que frequência os conteúdos recuperados são úteis para a sua pesquisa?</h4>
       	<div class="col-lg-12">
       	<ul class="list-group">
				<li class="list-group-item">
					<span> <input id="utilidadeUteis" value="s" name="utilidadeUteis" type="radio" >
						<span >Sempre</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="utilidadeUteis" value="f" name="utilidadeUteis" type="radio" >
						<span >Frequentemente</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="utilidadeUteis" value="a" name="utilidadeUteis" type="radio" >
						<span >Ás vezes</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="utilidadeUteis" value="n" name="utilidadeUteis" type="radio" >
						<span >Nunca</span>
					</span>
				</li>
				
			</ul>
	 	</div>
		 	
	 	<h4> Como você avalia o grau de dificuldade da pesquisa?</h4>
       	<div class="col-lg-12">
       	<ul class="list-group">
				<li class="list-group-item">
					<span> <input id="grauDificuldade" value="f" name="grauDificuldade" type="radio" >
						<span >Fácil</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="grauDificuldade" value="r" name="grauDificuldade" type="radio" >
						<span >Regular</span>
					</span>
				</li>
				
				<li class="list-group-item">
					<span> <input id="grauDificuldade" value="d" name="grauDificuldade" type="radio" >
						<span >Difícil</span>
					</span>
				</li>				
				
			</ul>
	 	</div>
	 	
	 	<h4> De modo geral, como você avalia a BDJur?</h4>
       	<div class="col-lg-12">
       	<ul class="list-group">
				<li class="list-group-item list-group-item-danger">
					<span> <input id="avaliacaoBdjur" value="p" name="avaliacaoBdjur" type="radio" >
						<span >Péssimo</span>
					</span>
				</li>
				
				<li class="list-group-item list-group-item-warning">
					<span> <input id="avaliacaoBdjur" value="r" name="avaliacaoBdjur" type="radio" >
						<span >Ruim</span>
					</span>
				</li>
				
				<li class="list-group-item list-group-item-info">
					<span> <input id="avaliacaoBdjur" value="b" name="avaliacaoBdjur" type="radio" >
					<span>Bom</span>
					</span>
				</li>	
				
				<li class="list-group-item list-group-item-success">
					<span> <input id="avaliacaoBdjur" value="o" name="avaliacaoBdjur" type="radio" >
					<span>Ótimo</span>
					</span>
				</li>					
				
			</ul>
	 	</div>
	 	
	 	<h4>Deixe suas opiniões sobre a BDJur:</h4>
	 	<div class="col-lg-12">
 			<textarea rows="6" name="opinioesBDJur" id="opinioesBDJur" cols="3" class="form-control"></textarea>
	 	</div>
        	
        	<input type="submit" class="btn btn-success" name="submit" value="<fmt:message key="jsp.feedback.form.send"/>" />
       	</div>
    </form>

</dspace:layout>
