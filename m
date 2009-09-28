Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:46855 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZI1ThM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 15:37:12 -0400
Date: Mon, 28 Sep 2009 15:37:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Imre Kaloz <kaloz@openwrt.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	Florian Fainelli <florian@openwrt.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Makefile ref to non-existent
 CONFIG_ATHEROS_AR71XX
In-Reply-To: <op.u0zfaoao2s3iss@richese>
Message-ID: <alpine.LFD.2.00.0909281535570.11562@localhost>
References: <alpine.LFD.2.00.0909180959550.9988@localhost> <200909182004.54398.florian@openwrt.org> <20090928182944.GA4737@tuxdriver.com> <op.u0zfaoao2s3iss@richese>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-107313554-1254166629=:11562"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-107313554-1254166629=:11562
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 28 Sep 2009, Imre Kaloz wrote:

> On 2009.09.28. 20:29:45 John W. Linville <linville@tuxdriver.com> wrote:
>
> > On Fri, Sep 18, 2009 at 08:04:51PM +0200, Florian Fainelli wrote:
> > > Hi Robert,
> > >
> > > Le vendredi 18 septembre 2009 16:01:25, Robert P. J. Day a =C3=A9crit=
 :
> > > >   searching for Makefile references to Kconfig variables that don't
> > > > exist, and i find:
> > > >
> > > > =3D=3D=3D=3D=3D ATHEROS_AR71XX =3D=3D=3D=3D=3D
> > > > ./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR=
71XX)
> > > > +=3D
> > > > ahb.o
> > >
> > > We need it in OpenWrt and plan to send Atheros AR71xx SoC
> > > support soon, do not consider this for removal. Thanks
> >
> > Sure, fine...estimate when it will arrive?
> >
> > John
>
> When we got access to some more info on the AR7240 so we can finish
> the support for it.

  just FYI, i wasn't pushing to have it taken out, just pointing out
its current lack of use.  what someone decides to do about it is
entirely in their hands.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-107313554-1254166629=:11562--
