Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41801 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZH1NPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 09:15:21 -0400
Date: Fri, 28 Aug 2009 09:11:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 00/10] complete cfg80211 conversion
Message-ID: <20090828131132.GA32694@tuxdriver.com>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2009 at 01:27:42PM +0300, Jussi Kivilinna wrote:
> This patchset completes cfg80211 conversion of rndis_wlan. Tested connect with 
> wext-compat: WPA/WPA2-PSK, WEP work with station mode. Adhoc work with
> and without WEP. Throught nl80211 pretty much untested.

Awesome!  Hooray!

What is keeping this as RFC?  Time is short for inclusion in 2.6.32...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
