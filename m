Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:35645
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab2H2EHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 00:07:10 -0400
Message-ID: <503D9569.9080206@posedge.com> (sfid-20120829_060758_891347_BE3BDD5A)
Date: Wed, 29 Aug 2012 09:37:05 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <502E85D9.5050301@posedge.com>   <1345480718.4459.37.camel@jlt3.sipsolutions.net>   <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>   <50338E84.3050709@posedge.com>   <1345564421.10280.9.camel@jlt3.sipsolutions.net>   <5033CE76.6040306@posedge.com>   <1345619008.4635.3.camel@jlt3.sipsolutions.net>   <20120822090104.GA4959@redhat.com>   <1345626282.4635.8.camel@jlt3.sipsolutions.net>   <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>  <1345809927.6991.0.camel@jlt3.sipsolutions.net>  <50377CD9.3090204@posedge.com> <1345970386.3622.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1345970386.3622.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2012 02:09 PM, Johannes Berg wrote:
> On Fri, 2012-08-24 at 18:38 +0530, Mahesh Palivela wrote:
>
>>> We might need 20MHZ_NOHT or something?
>>
>> Yes, I missed that.
>> 20MHZ_NOHT in 5G band and legacy operation 2.4G band may be 5MHZ.
>
> We don't support 5/10 MHz (yet anyway), so we don't have to worry about
> that.
>
>
>
> Yes, but how's that related to how you specify the channel?
>
> joahnnes
>
To keep the backward compatibility, how about we still keep channel 
type. New enum value "NL80211_CHAN_VHT" tells us to look at the new 
channel_config structure. That way not every driver out there have to 
change to use the new channel config structure. Let me know.

Thanks,
Mahesh
