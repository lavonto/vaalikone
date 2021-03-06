/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package vaalikone;

import java.io.IOException;
import java.io.PrintWriter;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.persistence.Query;
import javax.servlet.http.HttpSession;
import persist.Vastaukset;

/**
 *
 * @author toni1523
 */
public class EPoisto extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        if (session.getAttribute("admin") != "admin") {
            request.getRequestDispatcher("AKirjautuminen.jsp")
                    .forward(request, response);
        }

        //Näytettävän tulosteen alustus
        String viesti = null;

        try {
            //Haetaan annettu ehdokasID
            int id = Integer.parseInt(request.getParameter("ehdokas_id"));

            //Alustetaan EntityManager   
            EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
            EntityManager em = emf.createEntityManager();
            //Suoritetaan query, jolla poistetaan ID:tä vastaavat vastaukset.  
            em.getTransaction().begin();
            Query query = em.createQuery("DELETE FROM Vastaukset v WHERE v.vastauksetPK.ehdokasId =:p");
            query.setParameter("p", id).executeUpdate();
            em.getTransaction().commit();
            //Lopuksi suljetaan yhteys
            em.close();
            //Viesti määräytyy sen mukaan onnistuiko poisto vai ei
            viesti = "Ehdokkaan vastaukset on poistettu onnistuneesti!";
        } catch (Exception e) {
            viesti = "Jotain meni vikaan, "
                    + "ehdokkaan vastauksia ei poistettu onnistuneesti! "
                    + e;

        } finally {
            //Asetetaan viesti atribuutiksi ja siirrytään takaisin admin sivulle.
            request.setAttribute("viesti", viesti);
            request.getRequestDispatcher("Admin.jsp")
                    .forward(request, response);
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
