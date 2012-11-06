Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2KFRP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 12:15:56 -0500
Message-ID: <1352222189.8814.5.camel@jlt4.sipsolutions.net> (sfid-20121106_181609_867170_1E12EF98)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 06 Nov 2012 18:16:29 +0100
In-Reply-To: <509943C1.6080300@ehuk.net>
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	  <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	  (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	  <509838F4.4010301@ehuk.net>
	 <1352188621.9440.4.camel@jlt4.sipsolutions.net>
	  <50992E0E.3040606@ehuk.net>
	  <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	  (sfid-20121106_165343_414402_7F00AE58) <1352219976.9440.18.camel@jlt4.sipsolutions.net>
	  <50993FC2.7040100@ehuk.net>
	 <1352220942.8814.0.camel@jlt4.sipsolutions.net>
	  (sfid-20121106_175519_403098_E3B30E7C) <1352221044.8814.1.camel@jlt4.sipsolutions.net>
	 <509943C1.6080300@ehuk.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 17:07 +0000, Eddie Chapman wrote:

> >>> So it seems the AP knows where it is, but is it not transmitting that to
> >>> the client?
> >>
> >> Evidently, I don't see a country IE in the iw scan output you posted.
> >
> > Then again, what version of iw do you have? This only applies if it's
> > version 0.9.20 or higher.

> I don't see a country specified in the output I sent you either. We're 
> talking about iw scan on the client right, not the AP?

Yes. The scan on the client shows the AP's information, after all.

> Over on the AP, I just looked in the web interface, and there is a drop 
> down box for "Regulatory Domain", and I have it set to "United Kingdom".

Right. It just doesn't seem to tell the client for some reason.

> nc6400 ~ # iw --version
> iw version 3.3

Right, ok. That would print the country information if it was there.

> You mentioned crda, it seems gentoo has it, I can install it on the 
> client if you think it will help in figuring this out?

No, I think actually *not* having it might be more helpful, although
once we have found the (different) solution(s) we'll have to make sure
we fix it in all possible places, including crda/regdb.

johannes

