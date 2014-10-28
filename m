Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:54845 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750900AbaJ1OyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:54:05 -0400
Message-ID: <1414508040.6643.5.camel@perches.com> (sfid-20141028_155408_986109_1FFA36CA)
Subject: Re: [PATCH 00/16] brcmfmac: wowl support and cleanup
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 28 Oct 2014 07:54:00 -0700
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-28 at 14:56 +0100, Arend van Spriel wrote:
> This series has a couple of wowl patches that were too late to make
> the 3.18 merge window. Apart from those there are a number of rename
> and rework patches that get rid of the terms dhd and wl.
> 
> The series is intended for 3.19 and applies to the master branch
> of the wireless-next repository.
> 
> Arend van Spriel (3):
>   brcmfmac: show firmware error as string in debug message
>   brcmfmac: remove unused defintion
>   brcmfmac: do not use firmware error code in driver
> 
> Hante Meuleman (13):
>   brcmfmac: Add wowl support for USB devices.
>   brcmfmac: Add wowl support for SDIO devices.
>   brcmfmac: Add wowl patterns support.
>   brcmfmac: (clean) Remove usb_rdl.h as it is not needed.
>   brcmfmac: (clean) Remove packet filter configuration.
>   brcmfmac: (clean) Move tracepoint related function.
>   brcmfmac: (clean) Rename files dhd_dbg to debug
>   brcmfmac: (clean) Rename dhd_bus.h in bus.h
>   brcmfmac: (clean) Rename dhd_common.c in common.c
>   brcmfmac: (clean) Rename files wl_cfg80211 to cfg80211
>   brcmfmac: (clean) Rename sdio related files.
>   brcmfmac: (clean) Rename sdio related files.
>   brcmfmac: (clean) Move sdio related function.

Does "(clean) " add anything to these commit subjects?


