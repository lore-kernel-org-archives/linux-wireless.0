Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4930 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2GCHLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:11:23 -0400
Message-ID: <4FF29B0A.4010204@broadcom.com> (sfid-20120703_091126_271135_DE6B70F0)
Date: Tue, 3 Jul 2012 09:11:06 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 16/18] brcmsmac: extend brcms_c_chipmatch() to
 also handle non PCIe devices
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-17-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-17-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> Now brcms_c_chipmatch() is also able to handle non PCI devices and also
> does some checking for SoC if they are supported by brcmsmac.
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 +-
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |   38 ++++++++++++++++----
>  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +-
>  3 files changed, 34 insertions(+), 9 deletions(-)

Gr. AvS



