Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:40340 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab0E1LKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 07:10:48 -0400
Message-ID: <4BFFA490.90600@digadd.de>
Date: Fri, 28 May 2010 13:10:08 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
References: <4BF795EB.9070902@digadd.de>	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>	 <4BFF9FC6.4030101@digadd.de> <1275044074.3909.72.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275044074.3909.72.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/2010 12:54 PM, Johannes Berg wrote:
> On Fri, 2010-05-28 at 12:49 +0200, Christian P. Schmidt wrote:
> 
>> I see a bunch of WLANs with levels between 180 and 225. I'll compare the
>> values to disconnected antennas while disassembling.
> 
> Those values make no sense to me .. can you use "iw scan" and tell us
> the dBm value?

This translates to -52 to -30dBm.

Well, maybe you can answer me a question I never dared to ask because I
felt stupid... I can't take the Intel card online with only ifconfig or
ip? I always get "unknown error 132" on ifconfig wlan0 up / ip link set
wlan0 up...

Regards,
Christian
