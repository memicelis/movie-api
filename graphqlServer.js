const { ApolloServer, gql } = require("apollo-server");

// Define the GraphQL schema
const typeDefs = gql`
  type Query {
    movies: [Movie]
    movie(id: ID!): Movie
  }

  type Movie {
    id: ID!
    title: String
    director: String
    releaseDate: String
  }
`;

// Define the resolvers
const resolvers = {
  Query: {
    movies: () => {
      // Fetch and return the list of movies
      // ...existing code...
    },
    movie: (parent, args) => {
      // Fetch and return a single movie by ID
      // ...existing code...
    },
  },
};

// Create an instance of ApolloServer
const server = new ApolloServer({ typeDefs, resolvers });

// Start the server
server.listen().then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
