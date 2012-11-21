Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4953 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2KUSAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 13:00:07 -0500
Message-ID: <50AD169D.3040206@broadcom.com> (sfid-20121121_190011_476904_6B10E40D)
Date: Wed, 21 Nov 2012 18:59:57 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "kbuild test robot" <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless-next:master 203/214]
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse:
 Using plain integer as NULL pointer
References: <50ac819d.deUknDDzRBMUnMNp%fengguang.wu@intel.com>
 <20121121141812.GB23606@thinkpad-t410>
In-Reply-To: <20121121141812.GB23606@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2012 03:18 PM, Seth Forshee wrote:
> On Wed, Nov 21, 2012 at 03:24:13PM +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
>> head:   e2ff0498409af6f2023f91aba07b281e5e87ee15
>> commit: b353dda485038d5033b066cc946dfcf66afae128 [203/214] brcmsmac: Use debug macros for general error and debug statements
>>
>>
>> sparse warnings:
>>
>> + drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:573:17: sparse: Using plain integer as NULL pointer
>
> There's actually a bug here. I'll send a patch.

So much for us reviewing your patches. The human eye can only see so 
much, the mind can only process so much. Where would we be without 
compilers. Using assemblers probably.

Gr. AvS


