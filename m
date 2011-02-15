Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49162 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1BOVYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 16:24:39 -0500
Message-ID: <4D5AEF0F.6000701@openwrt.org>
Date: Tue, 15 Feb 2011 22:24:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: wwguy <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Get/set Sensitivity for a radio?
References: <4D5AE1B5.8010302@candelatech.com> <1297801737.4723.25.camel@wwguy-ubuntu> <4D5AE56D.6060900@candelatech.com>
In-Reply-To: <4D5AE56D.6060900@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-15 9:43 PM, Ben Greear wrote:
> On 02/15/2011 12:28 PM, wwguy wrote:
>> On Tue, 2011-02-15 at 12:27 -0800, Ben Greear wrote:
>>> Hello!
>>>
>>> I'm having no luck finding where sensitivity is set in
>>> net/mac80211.  Anyone know something to grep for?
>>>
>> I am not sure mac80211 deal with sensitivity if it's what you referring
>> (at least not I am aware of).
>>
>> in iwlwifi, driver and uCode take care of sensitivity calibration.
> 
> I'm messing with ath9k mostly.  Just trying to probe some values
> for reporting as of now.  In the old days, seems you could
> set the sensitivity for madwifi though..could help in some
> cases...
It doesn't make sense to try to add a single 'sensitivity' knob. There
are many different radio parameters that are related to that, some
calibrated, some configured - madwifi never had anything useful for that
either.

- Felix
