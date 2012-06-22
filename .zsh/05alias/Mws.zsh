hash -d www=/usr/wvgs/web
hash -d mws=/usr/wvgs/web/MWS
hash -d scripts=/usr/wvgs/lib/scripts/
hash -d ms=/usr/wvgs/lib/scripts/MWS
hash -d me2=/usr/wvgs/lib/scripts/me2
hash -d reg=/usr/wvgs/lib/scripts/register
hash -d reglib=/usr/wvgs/lib/register

allservers()
{
  coproc for i in mws{000..011} mjp208 mjp209 mws{21..25} mws{100..106} mws{300..311}; do ssh $i print \`uname -n\` \`${=@}\` &; done && cat <&p
}
