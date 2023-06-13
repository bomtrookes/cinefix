import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['query'];

  connect() {
    console.log('Search controller connected...');
  }

  performSearch(event) {
    console.log(query);
    event.preventDefault();
    const query = this.queryTarget.value;
    fetch('/search', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ query: query })
    })
    .then(response => response.json())
    .then(data => {
      // Update the movie list
      const moviesContainer = document.querySelector('#movies-container');
      moviesContainer.innerHTML = data.movies;

      // Update the cast & crew section
      const castCrewContainer = document.querySelector('#cast-crew-container');
      castCrewContainer.innerHTML = data.castCrew;

      // Update the users section
      const usersContainer = document.querySelector('#users-container');
      usersContainer.innerHTML = data.users;
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
}
