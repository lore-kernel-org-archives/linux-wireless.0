Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:45599 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbZGJVgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 17:36:11 -0400
Date: Fri, 10 Jul 2009 22:09:33 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Corentin Chary <corentin.chary@gmail.com>,
	debian-eeepc-devel@lists.alioth.debian.org,
	acpi4asus-user@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.31] rfkill: allow toggling soft state in sysfs again
Message-ID: <507E47A184%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1247254899.21972.9.camel@johannes.local>
References: <4A5716AA.5000903@ph.tum.de>
 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com>
 <4A5743AB.6090303@ph.tum.de>
 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com>
 <4A575119.9070505@ph.tum.de> <507E3B9268%linux@youmustbejoking.demon.co.uk>
 <1247254899.21972.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I demand that Johannes Berg may or may not have written...

> Apparently there actually _are_ tools that try to set this in sysfs even
> though it wasn't supposed to be used this way without claiming first.

Then it should have been documented as such. I don't see anything about this
in Documentation/rfkill.txt (as found in 2.6.30), other than a vague
statement that "Kernel handles events", which isn't exactly helpful :-\

> Guess what: now that I've cleaned it all up it doesn't matter and we can
> simply allow setting the soft-block state in sysfs.

:-)

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> *shrug*, I don't like it, but whatever...

I do. It means that we have a nice simple text-based interface for use in
scripts (for now), and a binary interface which is better suited to the likes
of desktop applications.

> Please test & report.

With the patch applied, Bluetooth toggling is working again, so you get to
add this:

Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

[snip]
-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Output *more* particulate pollutants.      BUFFER AGAINST GLOBAL WARMING.

For sale: one complete set of hen's teeth.
