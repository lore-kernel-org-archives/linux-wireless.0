Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:40210 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0FCP5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 11:57:52 -0400
Message-ID: <4C07D0C7.8010907@digadd.de>
Date: Thu, 03 Jun 2010 17:56:55 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
References: <4BF795EB.9070902@digadd.de>	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>	 <4BFF9FC6.4030101@digadd.de>	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de> <1275045843.3909.92.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275045843.3909.92.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 05/28/2010 01:24 PM, Johannes Berg wrote:
> On Fri, 2010-05-28 at 13:10 +0200, Christian P. Schmidt wrote:
> 
>>> Those values make no sense to me .. can you use "iw scan" and tell us
>>> the dBm value?
>>
>> This translates to -52 to -30dBm.
> 
> Ok that sounds like you have antennas.

Yes, I double checked it. Associations with my Linksys WRT54G running
OpenWRT times out as well, two laptops can successfully connect.

> Maybe try the rfkill tool:
> http://wireless.kernel.org/en/users/Documentation/rfkill

Yes, it was the rfkill tool that caused my attempts to fail. However,
this didn't change my association attempt problems.
I also took my time to look at the PCIe port - steady 3.3V on the RFKILL
pin, which means "no RFKILL".

Any further ideas?

Regards,
Christian
