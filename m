Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45887 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbXK2Vtb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 16:49:31 -0500
Subject: Re: mac80211 broken wifi packadges
From: Pavel Roskin <proski@gnu.org>
To: =?iso-8859-2?Q?Sz=F6ll=F5si?= Imre <imi@szollosi.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <474EAD65.5050103@szollosi.net>
References: <474EAD65.5050103@szollosi.net>
Content-Type: text/plain; charset=iso-8859-2
Date: Thu, 29 Nov 2007 16:49:29 -0500
Message-Id: <1196372969.3350.9.camel@dv> (sfid-20071129_214933_383535_571C2C12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-29 at 13:15 +0100, Sz=F6ll=F5si Imre wrote:
> Hello!
>=20
> Sorry about breaking the work.
> I'm a student from hungary and I have a trouble. My challange is, the=
=20
> get and use the broked wifi packadge.

Please don't post the same thing several time.  I also suggest that you
use a spellchecker, so that your e-mail is more readable.

I assume "packadge" means "packet".

> I sawed, the mac80211 is able to monitor mode with an virtual interfa=
ce,=20
> but it's only get good  packedges of wireless traffic. We want to use=
 it=20
> to completion a wireless stream traffic.

You probably mean that you want to receive packets with incorrect
checksum.

I checked the sources quickly, and I think you could try to change the
first "return 1" with "return 0" in should_drop_frame() in
net/mac80211/rx.c

Also, you may get better replies if you mention the kernel version, the
driver name and other relevant technical details.

> My question is, can you give me some instuction, how can i modify the=
=20
> stack, or can you give me a patch? I'm not a programmer, only learn=20
> infocommunication.

Generally, this list is not the place where you can expect others to do
your homework.

> Can you help me?

The last question is answered here:
http://www.catb.org/~esr/faqs/smart-questions.html#prune

--=20
Regards,
Pavel Roskin
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
