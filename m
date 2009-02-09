Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:47961 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZBJPhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:37:53 -0500
Subject: Re: AP mode support requirements for iwlagn driver
From: Milan Plzik <milan.plzik@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1233953240.4175.29.camel@johannes.local>
References: <1233933392.6476.2372.camel@localhost>
	 (sfid-20090206_164648_314946_F5B48388)  <1233953240.4175.29.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Feb 2009 23:15:11 +0100
Message-Id: <1234217712.6695.51.camel@localhost> (sfid-20090210_163756_471280_6E31DEB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

V Piatok, 6. febru=C3=A1r 2009 o 21:47 +0100, Johannes Berg nap=C3=ADsa=
l(a):
> On Fri, 2009-02-06 at 16:16 +0100, Milan Plzik wrote:
> > Hello,
> >=20
> >   what are the exact requirements for AP mode support in iwlagn dri=
ver?
> > Is there any change neccessary in card's firmware, or the only miss=
ing
> > code is in mac80211/iwlagn itself? Also, there was sort-of support =
for
> > AP, but it was disabled in later versions -- what were the exact
> > problems with this implementation?
>=20
> One major issue was getting multicast frames out at the right time, b=
ut
> also look at
> http://wireless.kernel.org/en/developers/Documentation/mac80211/API

  Ok, so from what I understand to get AP mode fully working, firmware
has to adjust TSF -- this seems to be what TX_CMD_FLG_TSF_MSK does;
everything other should be manageable by software.=20

  Btw, the URL unfortunately doesn't mention anything about multicast
frames;  if there something describing this more in detail?

>=20
> johannes

	Milan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
