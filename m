Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64302 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcAGXFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 18:05:17 -0500
Message-ID: <568EEF26.2060401@broadcom.com> (sfid-20160108_000525_440492_DFDCF869)
Date: Fri, 8 Jan 2016 00:05:10 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] brcmfmac: extend wowl and cleanup
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2016 11:05 AM, Arend van Spriel wrote:
> This smallish series contains:
> * link down fix for IBSS.
> * support wowl upon net detect.
> * cleanup timeout definitions.
>
> The series are intended for 4.5 kernel and apply to
> the master branch of wireless-drivers-next repo on top
> of series posted earlier with Message-ID:
>
> <1451724102-21911-1-git-send-email-arend@broadcom.com>

Hi Kalle,

Is this one I send last tuesday going to make it. I did not get any 
remarks on these patches so.. pretty please ;-)

Regards,
Arend

> Arend van Spriel (3):
>    brcmfmac: change brcmf_sdio_wd_timer() prototype
>    brcmfmac: use msecs_to_jiffies() in macro definitions
>    brcmfmac: use jiffies for timeout in btcoex
>
> Hante Meuleman (3):
>    brcmfmac: Add wowl net detect support
>    brcmfmac: Reshuffle functions to avoid forward declarations
>    brcmfmac: Do not handle link downs for ibss.
>
>   .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   12 +-
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 1116 +++++++++++---------
>   .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   29 +-
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    4 +-
>   .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +
>   .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    4 +-
>   .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   18 +-
>   .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    7 +-
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   51 +-
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    6 +-
>   .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    5 +-
>   11 files changed, 683 insertions(+), 571 deletions(-)
>

