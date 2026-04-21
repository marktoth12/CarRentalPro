import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/public/HomeView.vue'
// Fix import az ügynök dashboardhoz, hogy kizárjuk az elérési út hibákat
import AgentDashboardView from '../views/app/agent/AgentDashboardView.vue'

const routes = [
    {
        path: '/',
        name: 'Home',
        component: HomeView
    },
    {
        path: '/vehicles',
        name: 'Vehicles',
        component: () => import('../views/public/VehiclesView.vue')
    },
    {
        path: '/vehicles/:id',
        name: 'VehicleDetails',
        component: () => import('../views/public/VehicleDetailsView.vue')
    },
    {
        path: '/about',
        name: 'About',
        component: () => import('../views/public/AboutView.vue')
    },
    {
        path: '/contact',
        name: 'Contact',
        component: () => import('../views/public/ContactView.vue')
    },
    {
        path: '/auth/login',
        name: 'Login',
        component: () => import('../views/login/LoginView.vue')
    },
    {
        path: '/auth/register',
        name: 'Register',
        component: () => import('../views/login/RegisterView.vue')
    },
    {
        path: '/admin',
        name: 'AdminDashboard',
        component: () => import('../views/app/admin/AdminDashboardView.vue')
    },
    {
        path: '/agent',
        name: 'AgentDashboard',
        component: AgentDashboardView
    },
    {
        path: '/my-rentals',
        name: 'MyRentals',
        component: () => import('../views/app/user/MyRentalsView.vue')
    },
    {
        path: '/policies/aszf',
        name: 'Aszf',
        component: () => import('../policies/aszf.vue')
    },
    {
        path: '/policies/privacy',
        name: 'Privacy',
        component: () => import('../policies/privacy.vue')
    },
    {
        path: '/policies/cookie',
        name: 'Cookie',
        component: () => import('../policies/cookie.vue')
    }
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes
})

export default router