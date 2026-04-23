import { ref } from 'vue'

/**
 * Globális autentikációs állapot
 */

const isAuthenticated = ref(false)   // Be van-e jelentkezve a felhasználó?
const user = ref(null)               // A bejelentkezett felhasználó adatai

/**
 * Auth composable - központi autentikációs logika
 */
export const useAuth = () => {

    /**
     * Bejelentkezés
     * @param {string} email - Felhasználó email címe
     * @param {string} role - Felhasználó szerepköre (user, rentalagent, admin)
     * @param {string} token - Sanctum token (élesben a backend küldi)
     */
    const login = (email, role, token = "dummy-token") => {
        // Felhasználó adatainak mentése
        user.value = { email, role }
        isAuthenticated.value = true

        // Adatok mentése localStorage-ba (oldaltöltés után is megmarad)
        localStorage.setItem('user', JSON.stringify(user.value))
        localStorage.setItem('userRole', role)
        localStorage.setItem('token', token)
    }

    /**
     * Kijelentkezés
     * Minden auth adatot töröl
     */
    const logout = () => {
        user.value = null
        isAuthenticated.value = false

        // LocalStorage kiürítés
        localStorage.removeItem('user')
        localStorage.removeItem('token')
        localStorage.removeItem('userRole')
    }

    /**
     * Oldal betöltéskor ellenőrzi, van-e érvényes bejelentkezés
     */
    const checkAuth = () => {
        const storedUser = localStorage.getItem('user')
        const storedToken = localStorage.getItem('token')

        if (storedUser && storedToken) {
            user.value = JSON.parse(storedUser)
            isAuthenticated.value = true
        } else {
            user.value = null
            isAuthenticated.value = false
        }
    }

    /**
     * Visszaadott értékek és metódusok
     */
    return {
        // Reaktív állapot
        isAuthenticated,
        user,

        // Metódusok
        login,
        logout,
        checkAuth
    }
}