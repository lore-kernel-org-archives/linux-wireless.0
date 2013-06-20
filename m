Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linode.cmadams.net ([209.123.162.222]:45864 "EHLO
	linode.cmadams.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab3FTAeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 20:34:04 -0400
Date: Wed, 19 Jun 2013 19:28:38 -0500
From: Chris Adams <cma@cmadams.net>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
Message-ID: <20130620002838.GA8252@cmadams.net> (sfid-20130620_023424_303420_96BC6964)
References: <20130619160911.GB4784@cmadams.net>
 <51C1DDEB.3090701@lwfinger.net>
 <20130619164227.GC4784@cmadams.net>
 <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
 <20130619175850.GD4784@cmadams.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130619175850.GD4784@cmadams.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once upon a time, Chris Adams <cma@cmadams.net> said:
> The AP appears to be an Adtran (don't know the model).

The issue appears to be specific to the Adtran AP combined with the b43
device.  I have a D-Link DIR-625 at home (running OpenWRT 12.09, using
ath9k wireless driver), and the MacBook seems to stay connected to it
okay.

-- 
Chris Adams <cma@cmadams.net>
