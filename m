Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2863 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2BVRMX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 12:12:23 -0500
Message-ID: <4F4521EB.4090709@broadcom.com> (sfid-20120222_181251_007435_E8375843)
Date: Wed, 22 Feb 2012 18:12:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/15] brcm80211: resolve brcmsmac issues and
 brcmfmac usb support
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 09:08 PM, Arend van Spriel wrote:
> This patch series contains patches for a couple of issue in brcmsmac. The A-MPDU
> endless retry fix is a long standing issue that exists in previous kernels. So
> it should go to 3.3 kernel.
>
> For the brcmfmac driver support has been added for USB chipsets. Firmware has
> been submitted for bcm43235, bcm43236, and bcm43238 chipsets.
>

Hi John,

I send this patch series a while ago. I wanted to be sure whether they 
are scheduled to be taken in or is there some issue with it that we need 
to address, eg. indentation ;-) I looked in my email archive for 
community response and did not see any obvious show stopper there.

One patch in the series is same as I attached to redhat bug 787649 (see 
[1]).

Regards,
AvS

[1] https://bugzilla.redhat.com/show_bug.cgi?id=787649

