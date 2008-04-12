Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:14220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbYDLKpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 06:45:13 -0400
Received: by fg-out-1718.google.com with SMTP id l27so715290fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 03:45:11 -0700 (PDT)
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Sat, 12 Apr 2008 12:46:44 +0200
Cc: linux-wireless@vger.kernel.org
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
In-Reply-To: <47FE8FAD.9020802@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200804121246.44236.IvDoorn@gmail.com> (sfid-20080412_114523_159074_A265962F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 April 2008, Thomas B=E4chler wrote:
> Ivo van Doorn schrieb:
> >>>> Does the above mean that the stock driver in 2.6.25 will still b=
e slow?
> >>> Most likely yes.
> >>> Although I hear mixed reports, some say it depends on the rate se=
lection
> >>> algorithm, some claim rt2x00 in 2.6.24 is faster then wireless-te=
sting and
> >>> others claim the exact opposite.
> >>> At the moment it is hard to tell, but I haven't collected data ye=
t with specific
> >>> information about the used rate selection module and exact data t=
ransfer
> >>> numbers.
> >>>
> >>> Ivo
> >>>
> >> I rebuilt 2.6.25-rc8 (again) to use the 'simple' algorithm instead=
 of=20
> >> the 'PID' algorithm by default. rt2500pci is still fast!
> >=20
> > Good to hear. :)
> >=20
> > Thanks for the test.
> >=20
> > Ivo
>=20
> Bad news again:
>=20
> With 2.6.25-rc8, rt2500pci is fast. When I apply this patch:
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc8=
-git8.bz2
> on top of rc8, then it is slow again. I can't make sense of it, maybe=
=20
> you can.

Not really, looking at that patchset neither rt2x00 or mac80211 had any=
 patches
that could influence packet flow.. :S

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
