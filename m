Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4505 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2GCHLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:11:45 -0400
Message-ID: <4FF29B2A.5000401@broadcom.com> (sfid-20120703_091150_387477_A56785FC)
Date: Tue, 3 Jul 2012 09:11:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 18/18] brcmsmac: handle non PCI devices in the
 phy code
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-19-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-19-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> Some code in write_{radio,radio}_reg() should just be run if this is a
> pci based device. Add the condition again which was removed in commit:
> commit 821e4e93172e4f7d5ac1eade04665c3dc5049c4a
> Author: Roland Vossen <rvossen@broadcom.com>
> Date:   Mon Aug 8 15:58:58 2011 +0200
> 
>     staging: brcm80211: removed unused bus code from softmac
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Gr. AvS



