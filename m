Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2KFQ4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 11:56:45 -0500
Message-ID: <1352221044.8814.1.camel@jlt4.sipsolutions.net> (sfid-20121106_175700_534613_9E02EC7A)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 06 Nov 2012 17:57:24 +0100
In-Reply-To: <1352220942.8814.0.camel@jlt4.sipsolutions.net> (sfid-20121106_175519_403098_E3B30E7C)
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	 <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	 (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	 <509838F4.4010301@ehuk.net> <1352188621.9440.4.camel@jlt4.sipsolutions.net>
	 <50992E0E.3040606@ehuk.net>
	 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	 (sfid-20121106_165343_414402_7F00AE58) <1352219976.9440.18.camel@jlt4.sipsolutions.net>
	 <50993FC2.7040100@ehuk.net> <1352220942.8814.0.camel@jlt4.sipsolutions.net>
	 (sfid-20121106_175519_403098_E3B30E7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 17:55 +0100, Johannes Berg wrote:
> Hi Eddie,
> 
> > In the AP's dmesg output which I included in my other message, I see this:
> > 
> > <6>[    9.300000] cfg80211: Regulatory domain changed to country: GB
> > 
> > So it seems the AP knows where it is, but is it not transmitting that to 
> > the client?
> 
> Evidently, I don't see a country IE in the iw scan output you posted.

Then again, what version of iw do you have? This only applies if it's
version 0.9.20 or higher.

johannes

