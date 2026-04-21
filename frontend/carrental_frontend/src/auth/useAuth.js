import { ref, computed, onMounted } from 'vue'

const isAuthenticated = ref(false)
const user = ref(null)

export const useAuth = () => {
    const login = (email, role) => {
        user.value = { email, role }
        isAuthenticated.value = true
        localStorage.setItem('user', JSON.stringify(user.value))
        localStorage.setItem('userRole', role)
    }

    const logout = () => {
        user.value = null
        isAuthenticated.value = false
        localStorage.removeItem('user')
        localStorage.removeItem('token')
        localStorage.removeItem('userRole')
    }

    const checkAuth = () => {
        const storedUser = localStorage.getItem('user')
        const storedToken = localStorage.getItem('token')
        if (storedUser && storedToken) {
            user.value = JSON.parse(storedUser)
            isAuthenticated.value = true
        }
    }

    // Automatikus ellenőrzés
    onMounted(checkAuth)

    return {
        isAuthenticated: computed(() => isAuthenticated.value),
        user: computed(() => user.value),
        login,
        logout,
        checkAuth
    }
}