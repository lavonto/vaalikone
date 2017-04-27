<%-- 
    Document   : EMuokkaus
    Created on : Apr 27, 2017, 3:26:47 PM
    Author     : roope1301
--%>

<%@page import="javax.persistence.Query"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="javax.persistence.EntityManagerFactory"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="persist.Ehdokkaat" %>
<%@page session="true"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Ehdokkaiden lisääminen</title>
        <link href="style.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <%
            // Tarkistetaan onko "admin" -sessio olemassa ja jos ei niin ohjataan kirjautumiseen
            if (session.getAttribute("admin") != "admin") {
                request.getRequestDispatcher("AKirjautuminen.jsp")
                        .forward(request, response);
            }
        %>
        <div id="container">
            <img id="headerimg" src="Logo.png" width="720" />
            <h1>Ehdokkaiden lisääminen</h1>
            <%
                EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
                EntityManager em = emf.createEntityManager();

                Query q = em.createQuery(
                        "SELECT e FROM Ehdokkaat e");
                List<Ehdokkaat> kaikkiEhdokkaat = q.getResultList();
            %> 
            <form>
                <b>Lista olemassa olevista ehdokkaista:</b></br>
                <select>
                    <% for (int i = 1; i <= kaikkiEhdokkaat.size(); i++) {%>
                    <option><%= kaikkiEhdokkaat.get(i - 1).getEhdokasId()%>. <%= kaikkiEhdokkaat.get(i - 1).getEtunimi() + " " + kaikkiEhdokkaat.get(i - 1).getSukunimi()%></option>
                    <% }%>
                </select>
            </form></br>

            <form>
                <b>Lisää uusi:</b>
                Id:</br><input type="number" size ="3" name="id"/></br>
                Etunimi:</br><input type="text" maxlength="200" size="70" name="etunimi"/></br>
                Sukunimi:</br><input type="text" maxlength="200" size="70" name="sukunimi"/></br>
                Puolue:</br><input type="text" maxlength="200" size="70" name="puolue"/></br>
                Kotipaikkakunta:</br><input type="text" maxlength="200" size="70" name="paikkakunta"/></br>
                Ikä:</br><input type="text" maxlength="200" size="70" name="ika"/></br>
                Miksi eduskuntaan:</br><input type="text" maxlength="200" size="70" name="miksi"/></br>
                Mitä asioita haluat edistää?:</br><input type="text" maxlength="200" size="70" name="mita"/></br>
                Ammatti:</br><input type="text" maxlength="200" size="70" name="ammatti"/></br>
                <input type="submit" name="lisaa" value="Lisää" /></br>
            </form></br>
            <%
                if (request.getParameter("lisaa") != null) {
                    try {
                        String id = request.getParameter("id");
                        int i = Integer.parseInt(id);
                        String etunimi = request.getParameter("etunimi");
                        String sukunimi = request.getParameter("sukunimi");
                        String puolue = request.getParameter("puolue");
                        String paikka = request.getParameter("paikkakunta");
                        String ika = request.getParameter("ika");
                        int ik = Integer.parseInt(ika);
                        String miksi = request.getParameter("miksi");
                        String mita = request.getParameter("mita");
                        String ammatti = request.getParameter("ammatti");
                        
                        Ehdokkaat e = new Ehdokkaat(i);
                        e.setEtunimi(etunimi);
                        e.setSukunimi(sukunimi);
                        e.setPuolue(puolue);
                        e.setKotipaikkakunta(paikka);
                        e.setIkä(ik);
                        e.setMiksiEduskuntaan(miksi);
                        e.setMitaAsioitaHaluatEdistaa(mita);
                        e.setAmmatti(ammatti);

                        em.getTransaction().begin();
                        em.persist(e);
                        em.getTransaction().commit();
                        response.setHeader("Refresh", "0; http://localhost:8080/vaalikone/EMuokkaus.jsp");
                    } catch (Exception e) {
            %> Jokin meni vikaan, tarkista id. <%                                }

                }
            %>
            </form>

            </br>
            <a href="Admin.jsp">Takaisin</a>
        </div>
    </body>
</html>