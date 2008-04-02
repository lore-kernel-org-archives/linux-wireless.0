Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:61485 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbYDBRbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 13:31:32 -0400
Received: by fg-out-1718.google.com with SMTP id l27so2932330fgb.17
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 10:31:29 -0700 (PDT)
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Wed, 2 Apr 2008 19:32:25 +0200
Cc: linux-wireless@vger.kernel.org
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <200804012009.02448.IvDoorn@gmail.com> <47F35E1B.8000103@archlinux.org>
In-Reply-To: <47F35E1B.8000103@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200804021932.26046.IvDoorn@gmail.com> (sfid-20080402_183140_507501_D52179A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 April 2008, Thomas B=E4chler wrote:
> Ivo van Doorn schrieb:
> > Hi,
> >=20
> >>>> Is the last kernel code working with RaLink RT2500 802.11g Cardb=
us/mini-PCI?
> >>> With 'latest' do you mean:
> >>>  latest 2.6.25-rc kernel?
> >>>  latest wireless-testing git snapshot
> >>>  latest rt2x00 git snapshot
> >>>
> >>> The latter 2 should work fine, the first one has known issues
> >>> but the state variates per person.
> >> I was complaining about speed a while ago, so after reading this p=
ost, I=20
> >> thought I should try again and tell you:
> >>
> >> The version in wireless-testing seems to work great, a test downlo=
ad=20
> >> gave me 1.24MB/s, which is about the same speed I get with my (Int=
el=20
> >> wireless) laptop. I am using rt2500pci.
> >>
> >> Does the above mean that the stock driver in 2.6.25 will still be =
slow?
> >=20
> > Most likely yes.
> > Although I hear mixed reports, some say it depends on the rate sele=
ction
> > algorithm, some claim rt2x00 in 2.6.24 is faster then wireless-test=
ing and
> > others claim the exact opposite.
> > At the moment it is hard to tell, but I haven't collected data yet =
with specific
> > information about the used rate selection module and exact data tra=
nsfer
> > numbers.
> >=20
> > Ivo
> >=20
>=20
> I rebuilt 2.6.25-rc8 (again) to use the 'simple' algorithm instead of=
=20
> the 'PID' algorithm by default. rt2500pci is still fast!

Good to hear. :)

Thanks for the test.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
