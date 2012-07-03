Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1195 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCHIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:08:50 -0400
Message-ID: <4FF29A73.2080807@broadcom.com> (sfid-20120703_090853_758720_BEB90C75)
Date: Tue, 3 Jul 2012 09:08:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 13/18] brcmsmac: add some workarounds for other
 chips again
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-14-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-14-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> This adds some workarounds for the BCM4716, BCM47162, BCM5357 to the
> phy code again. This patch reverts parts of the following patch.
> 
> commit c2c724977f95135f397fe0cb45f3c041d26b91e1
> Author: Arend van Spriel <arend@broadcom.com>
> Date:   Wed Jun 29 16:46:35 2011 -0700
> 
>     staging: brcm80211: remove unsupported chipset code from brcmsmac phy
> 
> The BCM4716 is working for me with an other firmware and I am working
> on adding support for the other chips.
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  131 +++++++++++++-------
>  1 file changed, 89 insertions(+), 42 deletions(-)

Gr. AvS



