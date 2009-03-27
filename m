Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043AbZC0VbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:31:22 -0400
Subject: RE: [ipw3945-devel] New firmware available for Intel PRO/Wireless
	2200BG and 2915ABG
From: Dan Williams <dcbw@redhat.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B2E76C1D5@orsmsx502.amr.corp.intel.com>
References: <1237916524.455.18.camel@rc-desk>
	 <200903241855.06916.helmut.schaa@gmail.com>
	 <1237918158.455.26.camel@rc-desk>
	 <200903271637.42048.helmut.schaa@gmail.com>
	 <02B3067C068D0549A8CCFCB17D4D318B2E76C1D5@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Mar 2009 17:29:02 -0400
Message-Id: <1238189342.16870.12.camel@localhost.localdomain> (sfid-20090327_223138_286423_5ABEF8E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-27 at 11:55 -0700, Cahill, Ben M wrote:
>=20
> >-----Original Message-----
> >From: Helmut Schaa [mailto:helmut.schaa@googlemail.com]=20
> >Sent: Friday, March 27, 2009 11:38 AM
> >To: Chatre, Reinette
> >Cc: ipw2100-devel@lists.sourceforge.net;=20
> >linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net
> >Subject: Re: [ipw3945-devel] New firmware available for Intel=20
> >PRO/Wireless 2200BG and 2915ABG
> >
> >Am Dienstag, 24. M=C3=A4rz 2009 schrieb reinette chatre:
> >> Hi Helmut,
> >>=20
> >> On Tue, 2009-03-24 at 10:55 -0700, Helmut Schaa wrote:
> >> > Am Dienstag, 24. M=C3=A4rz 2009 schrieb reinette chatre:
> >> > > A new version (3.1) of firmware for Intel=C2=AE PRO/Wireless=20
> >2200BG and
> >> > > 2915ABG Drivers is now available for download from
> >> > > http://ipw2200.sourceforge.net/firmware.php.
> >> >=20
> >> > I couldn't find a changelog for the new firmware. Could=20
> >you point me to
> >> > a changelog or provide a short summary of what changed since 3.0=
?
> >>=20
> >> I am sorry, we were unable to obtain this information.
> >
> >Would be interesting if any firmware crashes got fixed with=20
> >that release (and
> >in which situations these happened). Nevertheless, good to see=20
> >that Intel
> >still pushes updates for older hardware :)
>=20
> Reports from the field are welcome.

Seems to have fixed the passive scan duration issue I used to get a few
times every day, but haven't seen since updating.  Helmut fixed the
driver [1], but I'm not running that patch yet.  Need to run for a bit
longer though to be more sure of this.

Dan

[1] [PATCHv2] ipw2200: fix scanning while associated


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
