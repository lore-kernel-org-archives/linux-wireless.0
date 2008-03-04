Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36573 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYCDRJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:09:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ahmed Ammar" <b33fc0d3@gmail.com>
Subject: Re: b43 (H/W 4306 Rev. 03)
Date: Tue, 4 Mar 2008 18:08:45 +0100
Cc: "Ivo Van Doorn" <ivdoorn@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Adam Baker" <linux@baker-net.org.uk>
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com> <a32f33a40802251427w678d57c1g1b85d7e72830a89e@mail.gmail.com> <84ac67910803040855x74d75412x424e220d61d459cb@mail.gmail.com>
In-Reply-To: <84ac67910803040855x74d75412x424e220d61d459cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803041808.45710.mb@bu3sch.de> (sfid-20080304_170938_320011_1ADA5E02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 March 2008 17:55:07 Ahmed Ammar wrote:
> > Yes, rt61pci is known to be buggy in monitor mode, there seem
> >  to be some inconsistencies regarding frame filtering inside the device
> >  which causes rt61pci to incorrectly filter some frames out.
> >
> >  It is an issue being looked into, and I believe Adam Baker already has
> >  some patches he will send in for rt2x00 soon (First some other TX/RX
> >  bugs needed to be fixed).
> >
> 
> Ok, well on that note I have updated my sources with latest
> wireless-testing.git and rt2x00.git (as of today). I think I have a
> better dump. But very few packets fom b43 are ever seen (I can only
> guess the tx code for my revision is borked?). b43legacy seems to show
> full output, but i might be wrong. Attached.

I don't know what you are doing, but we certainly don't support
hacking b43 to work on legacy devices or hacking b43legacy
to work on new devices, which it seems you did, right?

If you have some actual problem with some unmodified driver
version, please show us the problem and we will address it.

-- 
Greetings Michael.
