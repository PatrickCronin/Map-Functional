#include "EXTERN.h"
#include "perl.h"
#include "callchecker0.h"
#include "callparser.h"
#include "XSUB.h"

static OP *ck_entersub_map(pTHX_ OP *o, GV *namegv, SV *ud)
{
  PERL_UNUSED_ARG(namegv);
  PERL_UNUSED_ARG(ud);
  return o;
}

static OP *parse_map_args(pTHX_ GV *namegv, SV *ud, U32 *flagsp)
{
  int blk_floor = start_subparse(0, CVf_ANON);
  OP *blkop = newANONATTRSUB(blk_floor, NULL, NULL, parse_block(0));
  OP *args = parse_args_list(0);
  blkop = op_prepend_elem(OP_LIST, blkop, args);
  op_dump(blkop);
  return blkop;
}

MODULE = Map::Functional  PACKAGE = Map::Functional

void
fmap(...)
  PROTOTYPE:
  CODE:
    croak("foo");

BOOT:
{
  CV *map_cv = get_cv("Map::Functional::fmap", 0);
  cv_set_call_parser(map_cv, parse_map_args, (SV *)map_cv);
  cv_set_call_checker(map_cv, ck_entersub_map, (SV *)map_cv);
}
