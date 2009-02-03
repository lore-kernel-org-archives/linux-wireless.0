Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:62929 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZBCRFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 12:05:09 -0500
Message-ID: <49887936.3010203@lwfinger.net> (sfid-20090203_180517_583819_EBBBB77D)
Date: Tue, 03 Feb 2009 11:04:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 wireless issues
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>    <49871083.5040309@lwfinger.net>    <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>    <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>    <20090203142807.GC10968@tuxdriver.com> <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> 
> Apologies. there might be some confusion. When I mentioned the date of the
> 30/01/2009, I was referring to the snapshot date of the tarball
> downloaded, ie. compat-wireless-$(date -I).tar.bz2.
> 
> I haven't used wireless-testing's git repo thus far. If it will help with
> the rate issue I have then will definitely install that version instead.

Using the wireless-testing git tree would always keep your wireless
with the latest (and likely the greatest), that would probably be
overkill for you. I would just grab the latest snapshot from
compat-wireless. Something from 02/02 would have the latest rtl8187 code.

Larry
