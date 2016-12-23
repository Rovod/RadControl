#ifndef DETECTOR_H
#define DETECTOR_H
#include"DetectorData.h"
#include"interpolant.h"
#include<string>
namespace detector{
typedef unsigned char uchar;
class Detector{
public:
  ~Detector();
  void init(DetectorData*);
  void update();
  //void set_exposition(uint val); TODO
  //void set_exposition_by_count(uint val); TODO
  //void set_sensitivity(uint val); TODO
  int time_to_update;//milliseconds, set by update(), decreased by main()
private:
  DetectorData*d;
  bool configured;
  bool data_ready;
  bool problem_calibration;
  bool problem_connection;
  interpolant::Interpolant*calibration;//only for gamma
  void detector_log(std::string msg);
};
}
void log(std::string msg);
#endif
