/*----- PROTECTED REGION ID(RadCtrl.cpp) ENABLED START -----*/
static const char *RcsId = "$Id:  $";
//=============================================================================
//
// file :        RadCtrl.cpp
//
// description : C++ source for the RadCtrl class and its commands.
//               The class is derived from Device. It represents the
//               CORBA servant object which will be accessed from the
//               network. All commands which can be executed on the
//               RadCtrl are implemented in this file.
//
// project :     RadControl
//
// $Author:  $
//
// $Revision:  $
// $Date:  $
//
// $HeadURL:  $
//
//=============================================================================
//                This file is generated by POGO
//        (Program Obviously used to Generate tango Object)
//=============================================================================

#include<RadCtrl.h>
#include<RadCtrlClass.h>
#include<string>
using std::string;

/*----- PROTECTED REGION END -----*/	//	RadCtrl.cpp

/**
 *  RadCtrl class description:
 *    Controls gamma or neutron detectors
 */

//================================================================
//  The following table gives the correspondence
//  between command and method names.
//
//  Command name  |  Method name
//================================================================
//  State         |  Inherited (no method)
//  Status        |  Inherited (no method)
//  AlarmOFF      |  alarm_off
//================================================================

//================================================================
//  Attributes managed are:
//================================================================
//  count       |  Tango::DevULong	Scalar
//  background  |  Tango::DevFloat	Scalar
//  exposition  |  Tango::DevUShort	Scalar
//================================================================

namespace RadCtrl_ns
{
/*----- PROTECTED REGION ID(RadCtrl::namespace_starting) ENABLED START -----*/
/*----- PROTECTED REGION END -----*/	//	RadCtrl::namespace_starting

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::RadCtrl()
 *	Description : Constructors for a Tango device
 *                implementing the classRadCtrl
 */
//--------------------------------------------------------
RadCtrl::RadCtrl(Tango::DeviceClass *cl, string &s)
 : TANGO_BASE_CLASS(cl, s.c_str())
{
	/*----- PROTECTED REGION ID(RadCtrl::constructor_1) ENABLED START -----*/
	init(cl);
	init_device();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::constructor_1
}
//--------------------------------------------------------
RadCtrl::RadCtrl(Tango::DeviceClass *cl, const char *s)
 : TANGO_BASE_CLASS(cl, s)
{
	/*----- PROTECTED REGION ID(RadCtrl::constructor_2) ENABLED START -----*/
	init(cl);
	init_device();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::constructor_2
}
//--------------------------------------------------------
RadCtrl::RadCtrl(Tango::DeviceClass *cl, const char *s, const char *d)
 : TANGO_BASE_CLASS(cl, s, d)
{
	/*----- PROTECTED REGION ID(RadCtrl::constructor_3) ENABLED START -----*/
	init(cl);
	init_device();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::constructor_3
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::delete_device()
 *	Description : will be called at device destruction or at init command
 */
//--------------------------------------------------------
void RadCtrl::delete_device()
{
	DEBUG_STREAM << "RadCtrl::delete_device() " << device_name << endl;
	/*----- PROTECTED REGION ID(RadCtrl::delete_device) ENABLED START -----*/
	//	Delete device allocated objects
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::delete_device
	delete[] attr_count_read;
	delete[] attr_background_read;
	delete[] attr_exposition_read;
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::init_device()
 *	Description : will be called at device initialization.
 */
//--------------------------------------------------------
void RadCtrl::init_device()
{
	DEBUG_STREAM << "RadCtrl::init_device() create device " << device_name << endl;
	/*----- PROTECTED REGION ID(RadCtrl::init_device_before) ENABLED START -----*/
	//	Initialization before get_device_property() call
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::init_device_before
	

	//	Get the device properties from database
	get_device_property();
	
	attr_count_read = new Tango::DevULong[1];
	attr_background_read = new Tango::DevFloat[1];
	attr_exposition_read = new Tango::DevUShort[1];
	/*----- PROTECTED REGION ID(RadCtrl::init_device) ENABLED START -----*/
	//	Initialize device
	interpolant=nullptr;
	configured=false;
	data_ready=false;
	assure_configured();
	assure_calibrated();
	determine_state();
	DEBUG_STREAM<<"configured="<<configured<<";type="<<detector_type<<endl;
	DEBUG_STREAM<<"interpolant="<<interpolant<<";type="<<detector_type<<endl;
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::init_device
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::get_device_property()
 *	Description : Read database to initialize property data members.
 */
//--------------------------------------------------------
void RadCtrl::get_device_property()
{
	/*----- PROTECTED REGION ID(RadCtrl::get_device_property_before) ENABLED START -----*/
	//	Initialize property data members
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::get_device_property_before


	//	Read device properties from database.
	Tango::DbData	dev_prop;
	dev_prop.push_back(Tango::DbDatum("slave_id"));

	//	is there at least one property to be read ?
	if (dev_prop.size()>0)
	{
		//	Call database and extract values
		if (Tango::Util::instance()->_UseDb==true)
			get_db_device()->get_property(dev_prop);
	
		//	get instance on RadCtrlClass to get class property
		Tango::DbDatum	def_prop, cl_prop;
		RadCtrlClass	*ds_class =
			(static_cast<RadCtrlClass *>(get_device_class()));
		int	i = -1;

		//	Try to initialize slave_id from class property
		cl_prop = ds_class->get_class_property(dev_prop[++i].name);
		if (cl_prop.is_empty()==false)	cl_prop  >>  slave_id;
		else {
			//	Try to initialize slave_id from default device value
			def_prop = ds_class->get_default_device_property(dev_prop[i].name);
			if (def_prop.is_empty()==false)	def_prop  >>  slave_id;
		}
		//	And try to extract slave_id value from database
		if (dev_prop[i].is_empty()==false)	dev_prop[i]  >>  slave_id;

	}

	/*----- PROTECTED REGION ID(RadCtrl::get_device_property_after) ENABLED START -----*/
	//	Check device property data members init
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::get_device_property_after
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::always_executed_hook()
 *	Description : method always executed before any command is executed
 */
//--------------------------------------------------------
void RadCtrl::always_executed_hook()
{
	DEBUG_STREAM << "RadCtrl::always_executed_hook()  " << device_name << endl;
	/*----- PROTECTED REGION ID(RadCtrl::always_executed_hook) ENABLED START -----*/
	//	code always executed before all requests
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::always_executed_hook
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::read_attr_hardware()
 *	Description : Hardware acquisition for attributes
 */
//--------------------------------------------------------
void RadCtrl::read_attr_hardware(TANGO_UNUSED(vector<long> &attr_list))
{
	DEBUG_STREAM << "RadCtrl::read_attr_hardware(vector<long> &attr_list) entering... " << endl;
	/*----- PROTECTED REGION ID(RadCtrl::read_attr_hardware) ENABLED START -----*/
	//	Add your own code
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::read_attr_hardware
}

//--------------------------------------------------------
/**
 *	Read attribute count related method
 *	Description: Count during last exposition period
 *
 *	Data type:	Tango::DevULong
 *	Attr type:	Scalar
 */
//--------------------------------------------------------
void RadCtrl::read_count(Tango::Attribute &attr)
{
	DEBUG_STREAM << "RadCtrl::read_count(Tango::Attribute &attr) entering... " << endl;
	/*----- PROTECTED REGION ID(RadCtrl::read_count) ENABLED START -----*/
	const uint REGISTER_COUNT[]={104,38};//for gamma and netron detectors
	const uint REGISTER_COUNT_N[]={2,1};//size in 2-byte words
	int ret=-1;
	if(assure_configured()&&assure_data_ready()){
		uint reg=REGISTER_COUNT[detector_type];
		uint n=REGISTER_COUNT_N[detector_type];
		ret=read_register(attr,(uint16_t*)attr_count_read,reg,n);
		DEBUG_STREAM<<"reg="<<reg<<" n="<<n<<" ret="<<ret<<" attr_read="<<*attr_count_read<<endl;
		if(ret>0){
			if(n==1)((uint16_t*)attr_count_read)[1]=0;
			attr.set_value(attr_count_read);
		}else configured=false;
	}
	if(ret<0)attr.set_quality(Tango::ATTR_INVALID);
	determine_state();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::read_count
}
//--------------------------------------------------------
/**
 *	Read attribute background related method
 *	Description: Estimate of radiation background.
 *
 *	Data type:	Tango::DevFloat
 *	Attr type:	Scalar
 */
//--------------------------------------------------------
void RadCtrl::read_background(Tango::Attribute &attr)
{
	DEBUG_STREAM << "RadCtrl::read_background(Tango::Attribute &attr) entering... " << endl;
	/*----- PROTECTED REGION ID(RadCtrl::read_background) ENABLED START -----*/
	//	Set the attribute value
	const uint REGISTER_BACKGROUND[]={106,45};
	int ret=-1;
	if(assure_configured()&&assure_data_ready()&&assure_calibrated()){
		uint reg=REGISTER_BACKGROUND[detector_type];
		ret=read_register(attr,(uint16_t*)attr_background_read,reg,2);
		if(ret>0){
			if(detector_type==GAMMA)*attr_background_read=(*interpolant)(*attr_background_read);
			attr.set_value(attr_background_read);
		}else configured=false;
	}
	if(ret<0)attr.set_quality(Tango::ATTR_INVALID);
	determine_state();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::read_background
}
//--------------------------------------------------------
/**
 *	Read attribute exposition related method
 *	Description: 
 *
 *	Data type:	Tango::DevUShort
 *	Attr type:	Scalar
 */
//--------------------------------------------------------
void RadCtrl::read_exposition(Tango::Attribute &attr)
{
	DEBUG_STREAM << "RadCtrl::read_exposition(Tango::Attribute &attr) entering... " << endl;
	/*----- PROTECTED REGION ID(RadCtrl::read_exposition) ENABLED START -----*/
	const uint REGISTER_EXPOSITION[]={125,21};
	//TODO exposition register for neutron is something weird
	int ret=-1;
	if(assure_configured()){
		uint reg=REGISTER_EXPOSITION[detector_type];
		ret=read_register(attr,attr_exposition_read,reg);
		if(ret>0)attr.set_value(attr_exposition_read);
		else configured=false;
	}
	if(ret<0)attr.set_quality(Tango::ATTR_INVALID);
	determine_state();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::read_exposition
}

//--------------------------------------------------------
/**
 *	Method      : RadCtrl::add_dynamic_attributes()
 *	Description : Create the dynamic attributes if any
 *                for specified device.
 */
//--------------------------------------------------------
void RadCtrl::add_dynamic_attributes()
{
	/*----- PROTECTED REGION ID(RadCtrl::add_dynamic_attributes) ENABLED START -----*/
	//	Add your own code to create and add dynamic attributes if any
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::add_dynamic_attributes
}

//--------------------------------------------------------
/**
 *	Command AlarmOFF related method
 *	Description: Turns off alarm in this detector
 *
 */
//--------------------------------------------------------
void RadCtrl::alarm_off()
{
	DEBUG_STREAM << "RadCtrl::AlarmOFF()  - " << device_name << endl;
	/*----- PROTECTED REGION ID(RadCtrl::alarm_off) ENABLED START -----*/
	/*CODE NOT TESTED*/
	if(!assure_configured())return; 
	mtx->lock();
	modbus_set_slave(ctx,slave_id);
	if(detector_type==GAMMA){
		modbus_write_register(ctx,102,0);
	}else if(detector_type==NEUTRON){
		modbus_write_register(ctx,36,5);//write command 5 - alarm off - to command register
	}
	mtx->unlock();
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::alarm_off
}
//--------------------------------------------------------
/**
 *	Method      : RadCtrl::add_dynamic_commands()
 *	Description : Create the dynamic commands if any
 *                for specified device.
 */
//--------------------------------------------------------
void RadCtrl::add_dynamic_commands()
{
	/*----- PROTECTED REGION ID(RadCtrl::add_dynamic_commands) ENABLED START -----*/
	//	Add your own code to create and add dynamic commands if any
	/*----- PROTECTED REGION END -----*/	//	RadCtrl::add_dynamic_commands
}

/*----- PROTECTED REGION ID(RadCtrl::namespace_ending) ENABLED START -----*/
using Tango::Attribute;
int RadCtrl::read_register(Attribute&attr,uint16_t*dest,uint reg,uchar nwords){
	mtx->lock();
	modbus_set_slave(ctx,slave_id);
	int res=modbus_read_registers(ctx,reg,nwords,dest);
	mtx->unlock();
	if(res<0){
		DEBUG_STREAM<<"Failed to read "<<attr.get_name()<<endl;
		for(uint i=0;i<nwords;i++)dest[i]=0;
		return -1;
	  //TODO throw tango exception
	}else return res;
}
void RadCtrl::init(Tango::DeviceClass*cl){
	device_class=static_cast<RadCtrlClass*>(cl);
  mtx=device_class->mtx;	
  ctx=device_class->ctx;	
}
bool RadCtrl::assure_calibrated(){
	DEBUG_STREAM<<"assure_calibrated:entering"<<endl;
  if(detector_type==NEUTRON||interpolant!=nullptr)return true;
  string file=device_class->calibration_directory+'/'+to_string(slave_id)+".txt";
	try{
		interpolant=new Interpolant(file.c_str());
	}catch(...){
		interpolant=nullptr;
    cerr<<"ERROR:Failed to open file \""<<file<<"\";interpolant not initialised!"<<endl;
		return false;
	}
	return true;
}
bool RadCtrl::assure_configured(){
	if(configured)return true;//detector type has already been determined; detector has been commanded to do measurements
	//determine detector type - gamma or neutron - by reading offset of first register block
	uint16_t block=0;
	{lock_guard<mutex> lock(*mtx);
	modbus_set_slave(ctx,slave_id);
	int r=modbus_read_registers(ctx,3,1,&block);
	if(r<0)return false;
	if(block==20)detector_type=NEUTRON;
	else if(block==100)detector_type=GAMMA;
	else{
	  DEBUG_STREAM<<"Error:assure_configured: device with unexpected register block offset="<<block<<endl;	
		return false;
	}
	//set bits in command register to start measurements
	if(detector_type==NEUTRON){
		int r=modbus_write_register(ctx,36,1);//Write command id1(Output channel ON) to command register
		if(r<0)return false;
	}else{
	  data_ready=true;
	}
	}//release lock_guard
  configured=true;
	return true;
}
bool RadCtrl::assure_data_ready(){
	DEBUG_STREAM<<"assure_data_ready:entering"<<endl;
  if(detector_type==GAMMA)return true;
	uint16_t buf=0;
	int r=modbus_read_registers(ctx,37,1,&buf);//read bit 6(data ready) from status register
  if(r<0){
		configured=false;
	  DEBUG_STREAM<<"assure_data_ready:failed to read register, set configured to false"<<endl;
		return false;
	}
	data_ready=buf>>6&1;
	DEBUG_STREAM<<"assure_data_ready:data_ready="<<data_ready<<endl;
	return data_ready;
}
void RadCtrl::determine_state(){
	DEBUG_STREAM<<"determine_state:entering"<<endl;
	if(!configured){
	  set_state(Tango::FAULT);
		set_status("Tango device has failed to configure detector. Make sure the detector is powered and connected to the controlling computer.");
		return;
  }
	if(detector_type==GAMMA){
	  if(interpolant==nullptr){
			set_state(Tango::FAULT);
			set_status("Device server failed to load calibration data. Make sure file \"calibration/$slave_id.txt\" exists in TANGO server's working directory");
			return;
		}
	}else{
	  if(!data_ready){
			set_state(Tango::INIT);
			set_status("Device server is waiting for the detector to finish first measurement");
			return;
		}
	}
	set_state(Tango::ON);
	set_status("Device server is ready");
}
/*----- PROTECTED REGION END -----*/	//	RadCtrl::namespace_ending
} //	namespace