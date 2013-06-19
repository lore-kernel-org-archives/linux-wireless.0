Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linode.cmadams.net ([209.123.162.222]:45411 "EHLO
	linode.cmadams.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3FSSQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:16:10 -0400
Date: Wed, 19 Jun 2013 12:58:50 -0500
From: Chris Adams <cma@cmadams.net>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
Message-ID: <20130619175850.GD4784@cmadams.net> (sfid-20130619_201613_388753_7112831A)
References: <20130619160911.GB4784@cmadams.net>
 <51C1DDEB.3090701@lwfinger.net>
 <20130619164227.GC4784@cmadams.net>
 <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once upon a time, Rafał Miłecki <zajec5@gmail.com> said:
> I don't know how/if driver can be responsible for such reconnects.
> Over all it just TX and RX packets, right? Loosing a signal is
> something different, that can be related to the driver's bug. But as
> this happens every 5 minutes... I don't know.
> 
> Did you try connecting to this AP with any other card and using
> similar kernel? I wonder if this can be some supplicant / mac80211
> stack issue...

I just fired up my Thinkpad T510 with an Intel "Centrino Ultimate-N
6300" using iwlwifi, and it stays connected (does not appear to drop any
packets).  This is also Fedora 18 x86_64 (slightly older kernel, but
I've had the problem on the MacBook since I installed it).  There are
other people in the office with the same MacBook hardware (but running
OS X) that don't appear to be having any trouble either.

The AP appears to be an Adtran (don't know the model).

-- 
Chris Adams <cma@cmadams.net>
