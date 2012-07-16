Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47036 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2GPVod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 17:44:33 -0400
Message-ID: <50048B39.7060507@hauke-m.de> (sfid-20120716_234436_762340_1AB05BC1)
Date: Mon, 16 Jul 2012 23:44:25 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: REGRESSION: [PATCH v2 0/9] bcma misc updates
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de> <4FF29671.1020406@broadcom.com> <4FF2A2D4.9070308@hauke-m.de> <4FF2ABD6.3070007@broadcom.com>
In-Reply-To: <4FF2ABD6.3070007@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2012 10:22 AM, Arend van Spriel wrote:
> On 07/03/2012 09:44 AM, Hauke Mehrtens wrote:
>>> I suspect it tries reading OTP instead of the external SPROM.
>>>>
>>>> Gr. AvS
>>>>
>> Hi Arend,
>>
>> my BCM43224 uses a Sprom from the flash chip of the SoC, so it could be
>> that something is wrong in the sprom reading, but I haven't touched the
>> sprom code expect for using constants.
>>
>> Do you know which patch is causing this issue?
>>
>> Hauke
>>
> 
> I intended to bisect the series. I will let you know what I find.
> 
> Gr. AvS

Hi Arend,

Did you bisect this? I still have no idea which or why any of the
patches could cause this.

Hauke
