Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48303 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbZBBP0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 10:26:13 -0500
Message-ID: <49871083.5040309@lwfinger.net> (sfid-20090202_162617_592171_9586E8DA)
Date: Mon, 02 Feb 2009 09:25:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 wireless issues
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com> <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> That is a fair possibility. I upgraded the kernel on Saturday hence I had
> to rebuild against the new kernel. Upon install, I noticed that rtl8187
> was correctly installed. Of course, this second time of building and
> installing, I had removed the blacklist entries for rtl8187 as I had
> successfully used it for 24 hours.
> 
> One minor point, I notice in iwconfig is that it doesnt report a bit rate
> of greater than 1Mb/sec. Is this a known issue?

Please excuse my jumping into this thread, but the rate-setting
problem should be fixed in the latest compat-wireless. What version
are you using?

I just looked back at the patch log for wireless-testing. To get the
best code for the RTL8187, you should have compat-wireless from no
earlier than Jan. 28.

Larry
