Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40822 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1BOUn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:43:26 -0500
Message-ID: <4D5AE56D.6060900@candelatech.com>
Date: Tue, 15 Feb 2011 12:43:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: wwguy <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Get/set Sensitivity for a radio?
References: <4D5AE1B5.8010302@candelatech.com> <1297801737.4723.25.camel@wwguy-ubuntu>
In-Reply-To: <1297801737.4723.25.camel@wwguy-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 12:28 PM, wwguy wrote:
> On Tue, 2011-02-15 at 12:27 -0800, Ben Greear wrote:
>> Hello!
>>
>> I'm having no luck finding where sensitivity is set in
>> net/mac80211.  Anyone know something to grep for?
>>
> I am not sure mac80211 deal with sensitivity if it's what you referring
> (at least not I am aware of).
>
> in iwlwifi, driver and uCode take care of sensitivity calibration.

I'm messing with ath9k mostly.  Just trying to probe some values
for reporting as of now.  In the old days, seems you could
set the sensitivity for madwifi though..could help in some
cases...

Thanks,
Ben

>
> Wey
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

