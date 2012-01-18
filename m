Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:1259 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab2ARToF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 14:44:05 -0500
Message-ID: <4F172101.3010207@lenbrook.com> (sfid-20120118_204421_564087_C63F499D)
Date: Wed, 18 Jan 2012 14:44:01 -0500
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org
Subject: Re: ath6kl in compat wireless supports AP mode?
References: <4F10AA2D.1060000@lenbrook.com>	<4F16AF8D.6070201@qca.qualcomm.com> <20246.46742.295455.729628@gargle.gargle.HOWL>
In-Reply-To: <20246.46742.295455.729628@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith,

Can you tell me your setup for....

kernel ver?
hostapd ver?
libnl ver?
architecture ?

I'm running....
Compat-wireless 3.1 (ath6kl still in staging) built against kernel 2.6.35.3
     mac80211 as module
     cfg80211 as module
hostapd v2.0-devel (git cloned today)
libnl-2.0
arm, freescale imx51

I tried hostapd v2.0-devel and no go.

Jon

On 12-01-18 07:09 AM, Sujith Manoharan wrote:
> Kalle Valo wrote:
>> Hi Jonathan,
>>
>> sorry for answering late.
>>
>> On 01/14/2012 12:03 AM, Jonathan Bagg wrote:
>>> Anybody know if the ath6kl driver in compat wireless supports AP mode?
>>>
>>> hostapd hostapd.conf
>>> nl80211: Failed to set interface wlan0 into AP mode
>>> nl80211 driver initialization failed.
>>>
>>> hostapd.conf
>>> interface=wlan0
>>> driver=nl80211
>>> ssid=test
>>> channel=1
>>>
>>> Using
>>> hostapd v0.7.3
>>> libnl-2.0
>> Most of the ath6kl developers use wpasupplicants AP mode for this so I
>> recommend trying with wpasupplicant first. It might be that hostapd
>> requires something which ath6kl doesn't support.
> hostapd works fine, but a recent git version is probably required.
> v0.7.3 is a bit old, I think.
>
> Sujith

