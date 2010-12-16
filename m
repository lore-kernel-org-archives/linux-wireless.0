Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44799 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0LPMqB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:46:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 04:45:45 -0800
Message-ID: <4D0A0A03.7000704@atheros.com>
Date: Thu, 16 Dec 2010 18:15:55 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] ath9k_htc : Update txrate status to mac80211
References: <1292499588-11636-1-git-send-email-mshajakhan@atheros.com>	<19721.65246.410283.55163@gargle.gargle.HOWL>	<4D0A012E.3090408@atheros.com> <19722.1212.579544.451006@gargle.gargle.HOWL>
In-Reply-To: <19722.1212.579544.451006@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 December 2010 05:53 PM, Sujith wrote:
> Mohammed Shafi wrote:
>    
>> This patch just takes care for displaying the txrate and appropriately
>> sets mac80211 rate control flags,but completely ignores long retries.I
>> had tested it  , except retries the MCS index , txrate in userspace
>> matches with the txrate reported in debug statistics.
>>       Is there chance of any possible fix for this ?
>>      
> Not really, unless the FW is changed so that it can report TX status.
>    
Ok Sujith.
thanks,
shafi
> Sujith
> .
>
>    
