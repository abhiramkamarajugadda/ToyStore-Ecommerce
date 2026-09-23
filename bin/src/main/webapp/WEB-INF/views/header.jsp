<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    /* Custom Header Styling */
    header {
        background-color: #000; /* Solid black background */
        color: white; /* White text for contrast */
        display: flex;
        justify-content: space-between; /* Ensures the elements are spaced out */
        align-items: center;
        padding: 15px 20px; /* Spacing for a clean layout */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow effect */
    }

    /* Logo and Title Styling */
    header h1 {
        font-size: 1.8rem; /* Slightly larger font for the title */
        margin: 0;
        font-weight: bold;
    }

    /* User Info and Logout Styling */
    .user-info {
        display: flex;
        align-items: center;
    }

    .user-info p {
        margin: 0;
        margin-right: 15px; /* Space between username and button */
        font-size: 1rem;
    }

    .logout-btn {
        background-color: #dc3545; /* Bootstrap red color for contrast */
        border: none;
        padding: 5px 10px;
        color: white;
        font-size: 0.9rem;
        cursor: pointer;
        text-decoration: none;
        border-radius: 3px; /* Rounded corners */
    }

    .logout-btn:hover {
        background-color: #c82333; /* Slightly darker red on hover */
        text-decoration: none;
    }
</style>

<header>
    <!-- Left Corner: CGEcom Logo/Title -->
    <h1>CGEcom</h1>

    <!-- Right Corner: User Info and Logout -->
    <c:if test="${loggedInUser != null}">
        <div class="user-info">
            <p>Welcome, ${loggedInUser.username}!</p>
            <a href="/logout" class="logout-btn">Sign Out</a>
        </div>
    </c:if>
</header>
