Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35532 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYHASaU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 14:30:20 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KOzOI-0004HO-IL
	for linux-wireless@vger.kernel.org; Fri, 01 Aug 2008 18:30:14 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 18:30:14 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 18:30:14 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Vendor support stickers for devices supported under Linux
	wireless
Date: Fri, 1 Aug 2008 18:30:02 +0000 (UTC)
Message-ID: <g6vkn3$3lc$1@ger.gmane.org> (sfid-20080801_203024_512387_BECBB8EE)
References: <43e72e890807301327j54be2453r836964c708d75458@mail.gmail.com>
	<40f31dec0807310657l36b052bfu510415d50c14718d@mail.gmail.com>
	<3659.194.45.26.221.1217581093.squirrel@webmail.madwifi.org>
	<1217610561.13107.28.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 01 Aug 2008 13:09:21 -0400, Pavel Roskin wrote:

> On Fri, 2008-08-01 at 10:58 +0200, Michael Renzmann wrote:
>=20
>> How about a "Linux Wireless Foundation"? Some kind of official entit=
y
>> that wireless vendors could talk to for Linux support, certification
>> process for getting the logo, and so on.
>=20
> My concern is that giving any certification would imply that we promi=
se
> to keep the driver in the Linux sources.  However, I don't think we c=
an
> accept legal obligations on behalf of the developers.

Pardon me for butting in, but any vendor reading this thread would like=
ly=20
read "support" to mean user support, rather than exclusively developer=20
support. An often overlooked-by-vendors advantage of fully GPLing a=20
driver is that they can legitimately disclaim any and all end-user=20
support in favor of the community. If they don't fully GPL, they still=20
bear a user-support burden, regardless of whether they meet that burden=
=2E

A formal WiFi Foundation specific to the Linux kernel would be quite=20
excessive. There already is The Linux Foundation, which could potential=
ly=20
take care of any formal vendor liaison with the informal=20
linuxwireless.org group.

If certification is done, the most manageable way to do it would be for=
=20
vendors not to be able to choose what they can say about compatibility,=
=20
but just plaster on a logo with whatever number of "Tux"es shaded the=20
linuxwireless.org assigns them. This, of course, has the disadvantage o=
f=20
requiring retailers to replace compatibility stickers on retail boxes i=
f=20
and when the compatibility status of a device changes, but that would, =
of=20
course, be at vendor discretion.

Come to think of it, the above could apply to *any* hardware=E2=80=A6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
