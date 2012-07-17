Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1462 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2GQHbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 03:31:49 -0400
Message-ID: <500514D5.4090207@broadcom.com> (sfid-20120717_093153_714923_116D25B2)
Date: Tue, 17 Jul 2012 09:31:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: REGRESSION: [PATCH v2 0/9] bcma misc updates
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
 <4FF29671.1020406@broadcom.com> <4FF2A2D4.9070308@hauke-m.de>
 <4FF2ABD6.3070007@broadcom.com> <50048B39.7060507@hauke-m.de>
In-Reply-To: <50048B39.7060507@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2012 11:44 PM, Hauke Mehrtens wrote:
> On 07/03/2012 10:22 AM, Arend van Spriel wrote:
>> On 07/03/2012 09:44 AM, Hauke Mehrtens wrote:
>>>> I suspect it tries reading OTP instead of the external SPROM.
>>>>>
>>>>> Gr. AvS
>>>>>
>>> Hi Arend,
>>>
>>> my BCM43224 uses a Sprom from the flash chip of the SoC, so it could be
>>> that something is wrong in the sprom reading, but I haven't touched the
>>> sprom code expect for using constants.
>>>
>>> Do you know which patch is causing this issue?
>>>
>>> Hauke
>>>
>>
>> I intended to bisect the series. I will let you know what I find.
>>
>> Gr. Av
> 
> Hi Arend,
> 
> Did you bisect this? I still have no idea which or why any of the
> patches could cause this.
> 
> Hauke
> 

Hi Hauke,

I seem to have a number of issues with BCMA, which all seem host_pci
related. It looks like there is some merge issue in PCI API. It may be
due to the fact that wireless-testing got rebased by John and I merged
it into our internal branch.

So my plan is to rebase our internal branch to wireless-testing instead
of a merge. I did not come back to you because I wanted to make sense of
the issues I was seeing.

Gr. AvS

