Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbIFQrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 12:47:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Lin <dlin@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	"Chor Teck Law" <ctlaw@marvell.com>
Subject: Re: [PATCH] Add new mac80211 driver mwlwifi.
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	<1433598191.2467.65.camel@sipsolutions.net>
	<877fo3he8y.fsf@kamboji.qca.qualcomm.com>
	<55EC6453.3000601@broadcom.com>
Date: Sun, 06 Sep 2015 19:46:58 +0300
In-Reply-To: <55EC6453.3000601@broadcom.com> (Arend van Spriel's message of
	"Sun, 6 Sep 2015 18:05:39 +0200")
Message-ID: <87pp1vfqbh.fsf@kamboji.qca.qualcomm.com> (sfid-20150906_184713_785625_CA561B77)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 09/06/2015 03:24 PM, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>> On Thu, 2015-06-04 at 04:57 +0000, David Lin wrote:
>>>
>>>>   drivers/net/wireless/mwlwifi/Kconfig        |   17 +
>>>
>>> Does this driver has any relation to mwifiex? Perhaps the same
>>> maintainer team, etc.? Could consider moving all the Marvell drivers
>>> into one directory, but not really necessary I guess.
>>
>> Actually I would want to start adding vendor directories for wireless
>> drivers, just like drivers/net/ethernet has, to cleanup the directory
>> structure. So for example this driver we would have
>> drivers/net/wireless/marvell/mwlwifi and later we would start moving
>> existing drivers to vendor drivers as well. Thoughts?
>
> Right now our umbrella folder is brcm80211. I am fine changing it to
> broadcom if explicit vendor names are preferred although brcm80211
> still has my personal preference.

In your case I was actually thinking of moving it to broadcom/brcm80211.
And then we would also have broadcom/b43 and broadcom/b43legacy. So the
only change is addition of a new directory. How does that sound?

-- 
Kalle Valo
