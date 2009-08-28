Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:49928 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbZH1OeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 10:34:09 -0400
Message-ID: <20090828173410.11188widrsc7k4io@hayate.sektori.org>
Date: Fri, 28 Aug 2009 17:34:10 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 00/10] complete cfg80211 conversion
References: <20090828102742.15684.10566.stgit@fate.lan>
	<20090828131132.GA32694@tuxdriver.com>
In-Reply-To: <20090828131132.GA32694@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

> On Fri, Aug 28, 2009 at 01:27:42PM +0300, Jussi Kivilinna wrote:
>> This patchset completes cfg80211 conversion of rndis_wlan. Tested  
>> connect with
>> wext-compat: WPA/WPA2-PSK, WEP work with station mode. Adhoc work with
>> and without WEP. Throught nl80211 pretty much untested.
>
> Awesome!  Hooray!
>
> What is keeping this as RFC?  Time is short for inclusion in 2.6.32...
>

Other than question about mic failure key_id and nl80211 being  
untested, none I guess. If it all looks ok, it can be merged.

-Jussi


