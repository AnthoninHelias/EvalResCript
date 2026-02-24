import axios from 'axios';

const BASE_URL = 'https://qcm-api-a108ec633b51.herokuapp.com';

export const fetchQuestion = async (id) => {
  const response = await axios.get(`${BASE_URL}/response/${id}`);
  return response.data.rows[0].intitule;
};

export const fetchAnswers = async (id) => {
  const response = await axios.get(`${BASE_URL}/questions/${id}`);
  return response.data.rows.map(row => ({ title: row.titre, correct: row.correct }));
};
