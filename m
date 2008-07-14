Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbYGNUq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 16:46:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Subject: RE: [ipw3945-devel] iwl3945 random firmware crashes
Date: Mon, 14 Jul 2008 13:44:50 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017469B8@orsmsx413.amr.corp.intel.com> (sfid-20080714_224630_210209_AEA59C75)
In-reply-to: <69e28c910807141111l5af660e7l5e407a7b94a5cb79@mail.gmail.com>
References: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com><4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com> <69e28c910807141111l5af660e7l5e407a7b94a5cb79@mail.gmail.com>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: =?iso-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each bit enables a specific driver area/topic/type of debug messages ..=
=2E bits are defined by IWL_DL_ #defines in iwl-3945-debug.h ... 0x43ff=
f gives a nice cross section of debug messages without being *overly* v=
erbose.

-- Ben --

> -----Original Message-----
> From: ipw3945-devel-bounces@lists.sourceforge.net=20
> [mailto:ipw3945-devel-bounces@lists.sourceforge.net] On=20
> Behalf Of Stefanik G=E1bor
> Sent: Monday, July 14, 2008 2:11 PM
> To: Cahill, Ben M
> Cc: linux-wireless; ipw3945-devel
> Subject: Re: [ipw3945-devel] iwl3945 random firmware crashes
>=20
> On Mon, Jul 14, 2008 at 8:05 PM, Cahill, Ben M=20
> <ben.m.cahill@intel.com> wrote:
> > Try loading driver using module param:
> >
> > debug=3D0x43fff
> >
> > This will provide more information in the log, including an=20
> event log=20
> > (where you see "Microcode SW Error detected" in your log, you would=
=20
> > have captured Event Log if you had the debug=3D0x43fff setting).
> >
> > -- Ben --
>=20
> Just a question: Why are we using cryptic hex IDs for the=20
> debug setting? Is there a specific reason for this, or just=20
> noone has yet included proper modparams for the various=20
> debugging settings?
>=20
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>=20
> --------------------------------------------------------------
> -----------
> Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
> Studies have shown that voting for your favorite open source=20
> project, along with a healthy diet, reduces your potential=20
> for chronic lameness and boredom. Vote Now at=20
> http://www.sourceforge.net/community/cca08
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
