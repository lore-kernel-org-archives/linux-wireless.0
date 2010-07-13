Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:58713 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0GMNAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 09:00:09 -0400
Message-ID: <4C3C6350.50304@bu3sch.de>
Date: Tue, 13 Jul 2010 15:00:00 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Simon Richter <sjr@debian.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de> <1278887148.6139.91.camel@localhost> <4C3A4C6E.6060801@lwfinger.net> <20100713051430.GA2625@honey.hogyros.de> <4C3BFB87.5030907@lwfinger.net> <20100713073751.GB3089@richter> (sfid-20100713_093754_858982_FFFFFFFFE0C81FF9)
In-Reply-To: <20100713073751.GB3089@richter> (sfid-20100713_093754_858982_FFFFFFFFE0C81FF9)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2010 09:37 AM, Simon Richter wrote:
>>> That appears to work, at least I have v6 addresses now.
>> Unlike before, you now have communication.
> Well, v4 worked fine before. :)

That's very nice.
But I wanna say again that this all is expected behavior. The PIO
fallback workaround randomly drops packets when switching modes.
So it is expected that certain handshaking packages may be lost.

It's just a hackish workaround. No more, but also no less.

> I was also having some suspend related issues, I'm going to give it a
> few days now to see whether they also disappear now.

Please open a new bug for this. Thanks.

-- 
Greetings Michael.
