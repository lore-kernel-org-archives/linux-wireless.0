Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:40426 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768AbZKXSnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 13:43:00 -0500
Message-ID: <4B0C2938.1050604@irobot.com>
Date: Tue, 24 Nov 2009 10:43:04 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
References: <4AF0D54D.4090303@irobot.com>	 <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>	 <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>	 <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local>	 <4B0192A6.9050808@irobot.com>	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>	 <4B01D4A5.7060204@irobot.com>	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>	 <4B01E298.3030602@irobot.com>	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>	 <4B0C1E0A.9020003@irobot.com> <1259085518.3491.24.camel@johannes.local>	 <4B0C2720.3090308@irobot.com> <1259087819.3491.30.camel@johannes.local>
In-Reply-To: <1259087819.3491.30.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> However, that reminds me that I actually wanted to get rid of
> rate_init() since it's mostly not useful to have it separate from
> alloc_sta()... oh well.
>
> I suppose if we document clearly that rate_init maybe called multiple
> times and audit the existing algorithms the patch could be ok.
>   
As far as I can tell, minstrel_rate_init does not do any allocation.  
The pid_algo version does not appear to do any allocation either.

--Adam Wozniak
