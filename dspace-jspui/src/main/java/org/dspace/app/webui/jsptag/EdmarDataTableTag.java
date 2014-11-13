/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.jsptag;

import java.io.IOException;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.dspace.browse.BrowseItem;

public class EdmarDataTableTag extends SimpleTagSupport {
	private StringBuilder componenteEmHtml;
	private List<BrowseItem> items;
	
	public EdmarDataTableTag() {
		super();
		setComponenteEmHtml(new StringBuilder());
		
	}
	
	@Override
	public void doTag() throws JspException, IOException {
		JspWriter out = getJspContext().getOut();
		construirPanelComTable(getComponenteEmHtml());
		out.println(getComponenteEmHtml());
	}
	
	public void construirPanelComTable(StringBuilder sb) {
		abrirDivPanelPrimary(sb);
		abrirDivPanelHeading(sb);
		sb.append("Mostrando resultados 1 a 4 de 4");
		fecharDiv(sb);
		abrirTable(sb);
		sb.append("<colgroup><col width=\"130\"><col width=\"60%\"><col width=\"40%\"></colgroup>");
		abrirTBody(sb);
		for(BrowseItem itemTemp : getItems()) {
			abrirTr(sb);
			abrirTd(sb);
				sb.append("TESTE");
			fecharTd(sb);
			fecharTr(sb);
		}
		fecharTBody(sb);
		fecharTable(sb);
		abrirDivPanelFooter(sb);
		sb.append("Mostrando resultados 1 a 4 de 4");
		fecharDiv(sb);
		fecharDiv(sb);
	}

	private void abrirDivPanelFooter(StringBuilder sb) {
		sb.append("<div class=\"panel-footer text-center\">");
	}

	private void fecharTable(StringBuilder sb) {
		sb.append("</table>");
	}

	private void fecharTBody(StringBuilder sb) {
		sb.append("</tbody>");
	}

	private void fecharTr(StringBuilder sb) {
		sb.append("</tr>");
	}

	private void fecharTd(StringBuilder sb) {
		sb.append("</td>");
	}

	private void abrirTd(StringBuilder sb) {
		sb.append("<td>");
	}

	private void abrirTr(StringBuilder sb) {
		sb.append("<tr>");
	}

	private void abrirTBody(StringBuilder sb) {
		sb.append("<tbody>");
	}

	private void abrirTable(StringBuilder sb) {
		sb.append("<table align=\"center\" class=\"table\" summary=\"This table browses all dspace content\">");
	}

	private void fecharDiv(StringBuilder sb) {
		sb.append("</div>");
	}

	private void abrirDivPanelHeading(StringBuilder sb) {
		sb.append("<div class=\"panel-heading text-center\">");
	}

	private void abrirDivPanelPrimary(StringBuilder sb) {
		sb.append("<div class=\"panel panel-primary\">");
	}

	public StringBuilder getComponenteEmHtml() {
		return componenteEmHtml;
	}

	public void setComponenteEmHtml(StringBuilder componenteEmHtml) {
		this.componenteEmHtml = componenteEmHtml;
	}

	public List<BrowseItem> getItems() {
		return items;
	}

	public void setItems(List<BrowseItem> items) {
		this.items = items;
	}
	
	
	

}
