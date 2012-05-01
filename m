Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4131 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab2EAJfs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 05:35:48 -0400
Message-ID: <4F9FAE48.10102@broadcom.com> (sfid-20120501_113552_800786_19A457B9)
Date: Tue, 1 May 2012 11:35:04 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
 <4F9CF839.1040401@broadcom.com> <4F9D4073.200@hauke-m.de>
 <4F9D7032.40507@broadcom.com> <4F9DC495.7060103@hauke-m.de>
In-Reply-To: <4F9DC495.7060103@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2012 12:45 AM, Hauke Mehrtens wrote:
> On 04/29/2012 06:45 PM, Arend van Spriel wrote:
>> What firmware are you using?
>
> On b43 I am using firmware version 666.2 from wl 5.100.138, but also
> older versions are working. On brcmsmac I am using bcm43xx-0.fw and
> bcm43xx_hdr-0.fw from the linux-firmware git repo.
>
> Does the ucode you provide in bcm43xx-0.fw and bcm43xx_hdr-0.fw support
> rev 17 ieee80211 cores? For b43 it is the same file for all n-phy based
> cores rev>= 16, so for wl it should be the same, but have you added
> some special handling into this firmware for brcmsmac?
>
> Hauke
>

Yes, the firmware for brcmsmac is specifically for 43224, 43225, and 
4313. I have to check with the firmware guys here what is needed for 4718.

Gr. AvS

