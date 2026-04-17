import { ref, computed } from 'vue'

const isAuthenticated = ref(false)
const user = ref(null)
const token = ref(null)

export const useAuth = () => {
    const login = (email, password, role) => {
        user.value = {
            email,
            role: role || 'user'
        }
        token.value = 'demo-token-' + Date.now()
        isAuthenticated.value = true

        localStorage.setItem('user', JSON.stringify(user.value))
        localStorage.setItem('token', token.value)
        localStorage.setItem('userRole', user.value.role)
    }

    const logout = () => {
        user.value = null
        token.value = null
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
            token.value = storedToken
            isAuthenticated.value = true
        }
    }

    const getAuthToken = () => {
        return localStorage.getItem('token')
    }

    const getUser = () => {
        return JSON.parse(localStorage.getItem('user') || 'null')
    }

    const getUserRole = () => {
        return localStorage.getItem('userRole')
    }

    return {
        isAuthenticated: computed(() => isAuthenticated.value),
        user: computed(() => user.value),
        token: computed(() => token.value),
        login,
        logout,
        checkAuth,
        getAuthToken,
        getUser,
        getUserRole
    }
}

