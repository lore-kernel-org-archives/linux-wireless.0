Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2972 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2GCIWz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 04:22:55 -0400
Message-ID: <4FF2ABD6.3070007@broadcom.com> (sfid-20120703_102302_457655_5209F5C2)
Date: Tue, 3 Jul 2012 10:22:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: REGRESSION: [PATCH v2 0/9] bcma misc updates
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
 <4FF29671.1020406@broadcom.com> <4FF2A2D4.9070308@hauke-m.de>
In-Reply-To: <4FF2A2D4.9070308@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2012 09:44 AM, Hauke Mehrtens wrote:
>> I suspect it tries reading OTP instead of the external SPROM.
>> > 
>> > Gr. AvS
>> > 
> Hi Arend,
> 
> my BCM43224 uses a Sprom from the flash chip of the SoC, so it could be
> that something is wrong in the sprom reading, but I haven't touched the
> sprom code expect for using constants.
> 
> Do you know which patch is causing this issue?
> 
> Hauke
> 

I intended to bisect the series. I will let you know what I find.

Gr. AvS


