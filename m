Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47391 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYJTRBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 13:01:53 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kry8Z-0000pr-Pj
	for linux-wireless@vger.kernel.org; Mon, 20 Oct 2008 17:01:48 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 17:01:47 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 17:01:47 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Marvell TopDog Driver Work
Date: Mon, 20 Oct 2008 17:01:37 +0000 (UTC)
Message-ID: <gdidhg$hdq$3@ger.gmane.org> (sfid-20081020_190157_230217_22146B64)
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	<1218830917.14841.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 15 Aug 2008 16:08:37 -0400, Dan Williams wrote:

> On Fri, 2008-08-15 at 12:58 -0700, Luis R. Rodriguez wrote:
>> On Fri, Aug 15, 2008 at 12:40:27PM -0700, Pat Erley wrote:
>> > Has anyone stepped up to help in the port of this to mac80211?  I
>> > just picked up a wrvs4400n router that uses it and have been worki=
ng
>> > on getting 2.6.XX to work with it.
>>=20
>> Not that I have heard of. Don't know.
>=20
> There's code out there for the TopDog parts (Linville's marvell.git o=
n
> kernel.org), and I even have one or two of them lying around.  The
> firmware interface isn't that different from the 8335 (mrv8k) and thu=
s
> the two product lines can probably share the same driver.
>=20
> Lennert and Nick (from Marvell) are supposed to be working on a mac80=
211
> driver for the 88w8687 part, which is probably just about the same
> firmware interface as TopDog (aside from the N-specific bits, and
> different TX & RX descriptors I'm sure).  I'd prefer to either start
> fixing up mrv8k and then merge into whatever Lennert comes up with, o=
r
> see what they come up with and use that as a base for adding support =
for
> older TopDog and 8310/8335 hardware.
>=20
> mrv8k was always a bit rocky and never reliably got scan results on t=
he
> 8335 cardbus hardware I had, even though the descriptor setup and the
> mac80211 bits looked right.  There's some pre/post scan commands that=
 we
> need to hook into mac80211 which I posted patches for first, but
> Johannes requested we not commit those until we really knew whether
> pre/post scan were required.
>=20
> Dan

Duh...
http://git.kernel.org/?p=3Dlinux/kernel/git/mcgrof/mrvl_cb82.git;a=3Dsu=
mmary

Also, I have a router with an 8361 chip and Linux Inside=E2=84=A2 for w=
hich I=20
have made a GPL Source Request. I was told that the sources will be=20
available two weeks from now. I don't expect the wi-fi driver to be in=20
source form in that release, but you never know in advance what they'll=
=20
stuff in there.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
