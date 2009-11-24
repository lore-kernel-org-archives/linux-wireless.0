Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:18430 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbZKXT6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:42 -0500
Message-ID: <4B0C3AF6.7030407@irobot.com>
Date: Tue, 24 Nov 2009 11:58:46 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
References: <4AF0D54D.4090303@irobot.com>	 <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local>	 <4B0192A6.9050808@irobot.com>	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>	 <4B01D4A5.7060204@irobot.com>	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>	 <4B01E298.3030602@irobot.com>	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>	 <4B0C1E0A.9020003@irobot.com> <1259085518.3491.24.camel@johannes.local>	 <4B0C2720.3090308@irobot.com> <1259087819.3491.30.camel@johannes.local>	 <4B0C2938.1050604@irobot.com> <1259089255.3491.31.camel@johannes.local>	 <4B0C37AA.3070805@irobot.com> <1259092027.3491.33.camel@johannes.local>
In-Reply-To: <1259092027.3491.33.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Ok, but can they all deal with calling get_rate and rate_init at the
> same time? I think that could happen now, no?
>   
I understand your concern.  I do not know the code well enough to answer 
that question.

It seems like, if that is a real concern, it should be simple enough to 
guarantee that would never happen with a mutex.  But this is getting out 
of scope for the amount of time I have budgeted to pursue this issue.
