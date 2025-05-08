class EndPoints {
  static const baseUrl = 'http://13.127.94.103/pms/';
  static const baseUrlImages = 'http://13.127.94.103/pms/storage/';
  static const api = baseUrl + "api/";

  //--------------------------------- endpoints ---------------------------------
  static const login = '${api}login';
  static const departmentList = '${api}department-list';
  static const skillsList = '${api}list-skills';
  static const qualificationsList = '${api}list-qualification';
  static const domainList = '${api}list-resource-types';
  static const districtList = '${api}list-districts';
  static const addProject = '${api}project-save';
  static const getProjects = '${api}project-list';
  static const addTask = '${api}task-save';
  static const getTasks = '${api}task-list';
 // static const getTechStacks = '${api}tech-stack-list';
  static const getUserRoles = '${api}user-role-list';
  static const getDesignation = '${api}designation-list';
  static const addUserRole = '${api}add-user';
  static const getMembers = '${api}all-team-member';
  static const getTechLead = '${api}all-team-lead';
  static const addMilestone = '${api}milestone-save';
  static const getMilestone = '${api}milestone-list';
  static const updateTaskStatus = '${api}update-task-status';
  static const selfTasksList = '${api}self-tasks-list';
  static const saveSelfTask = '${api}save-self-task';
  static const projectDetails = '${api}project-detail';
  static const userList = '${api}user-list';
  static const employerList = '${api}list-employers';
  static const divisionsList = '${api}list-divisions';
  static const appraisalFormsList = '${api}list-appraisal-forms';
  static const selfAppraisalList = '${api}self-appraisal-list';
  static const saveSelfAppraisal = '${api}save-self-appraisal';
  static const userDetail = '${api}user-detail';

}
