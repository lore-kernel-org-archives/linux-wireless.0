Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39310 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbZCNS3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 14:29:21 -0400
Message-ID: <49BBF778.9090603@lwfinger.net> (sfid-20090314_192924_462368_46875F1F)
Date: Sat, 14 Mar 2009 13:29:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?VmlrdG9yIElsaWphxaFpxIc=?= <viktor.ilijasic@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 not handling my usb card
References: <4999F3A6.7020208@gmail.com> <4999F427.4060008@lwfinger.net>	 <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com>	 <499A00D7.1080000@lwfinger.net>	 <63d38a500902170149q275bcb87r9ada40439a013dc7@mail.gmail.com>	 <499AE03C.9050008@lwfinger.net>	 <63d38a500903141114m17d9123ey7d934cd05496c1c5@mail.gmail.com> <63d38a500903141116h3f998e6cl163e1d8c4f9e711d@mail.gmail.com>
In-Reply-To: <63d38a500903141116h3f998e6cl163e1d8c4f9e711d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Viktor Ilija=C5=A1i=C4=87 wrote:
> Hi, all.
>=20
> I received a new card, after the old one died, and I'm happy to repor=
t
> that the card works properly under Linux with my patched version of
> the driver (the patch was only to add the USB ID). I see that the
> patch was already submitted to the kernel while my card was being
> replaced.
>=20
> Thanks all for your work and help.

You are welcome. Thanks for reporting the new ID. That patch has been a=
pplied to
2.6.29-rcX and will appear in the next releases of 2.6.{27,28}.Y.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
