Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4427 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2FFJpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:45:12 -0400
Message-ID: <4FCF2698.6070401@broadcom.com> (sfid-20120606_114516_860984_00F47929)
Date: Wed, 6 Jun 2012 11:44:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/18] brcmsmac: use chip and package id constants
 from bcma
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-11-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-11-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   10 ----------
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |   12 ++++++------
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   10 +++++-----
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   20 ++++++++++----------
>  drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   12 ++++++------
>  5 files changed, 27 insertions(+), 37 deletions(-)


