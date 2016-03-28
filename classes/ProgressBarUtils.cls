public with sharing class ProgressBarUtils {

	public Campaign tactic{get;set;}

	public class stepWrapper{
		public String name{get;set;}
		public String url{get;set;}
		public Boolean isVisit{get;set;}
		public Boolean isCurrent{get;set;}

		public stepWrapper(String str, Boolean isv, Boolean isc, String ul){
			name = str;
			isVisit = isv;
			isCurrent = isc;
			url = ul;
		}
	}
	public List<String> stepList{set;get;}

	public List<stepWrapper> stepWrapperList{set;get;}

	public ProgressBarUtils(ApexPages.StandardController controller){
		tactic = (Campaign)controller.getRecord();
		tactic = [SELECT id, Tactic_Approval_Status__c, Budget_Change_Approval_Status__c FROM Campaign where id=:tactic.id];
		stepList = steps();

		stepWrapperList = setSteps();
	}

	public List<String> steps(){
		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = Campaign.Tactic_Approval_Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		
		for( Schema.PicklistEntry f : ple){
			options.add(f.getLabel());
		}
		return options;
	}

	public List<stepWrapper> setSteps(){
		List<stepWrapper> options = new List<stepWrapper>();
		Schema.DescribeFieldResult fieldResult = Campaign.Tactic_Approval_Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		
		Boolean isCurrent =false;
		Integer i = 1;
		for( Schema.PicklistEntry f : ple){

			if(f.getValue() == tactic.Tactic_Approval_Status__c){
				options.add( new stepWrapper(f.getLabel(), false, true, String.valueOf(i)));
				isCurrent = true;
			}else if(!isCurrent){
				options.add( new stepWrapper(f.getLabel(), true, false, String.valueOf(i)));
			}else if(isCurrent){
				options.add( new stepWrapper(f.getLabel(), false, false, String.valueOf(i)));
			}
			i++;
		}
		System.debug('*** options: ' + options + '');
		return options;
	}
}