Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4513 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab2FFJ1m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:27:42 -0400
Message-ID: <4FCF2283.3010708@broadcom.com> (sfid-20120606_112748_495730_01CA3F32)
Date: Wed, 6 Jun 2012 11:27:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/18] brcmsmac: use container_of instead of cast
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Nice. Could add a description that it gets rid of structure layout
requirement, ie. pub must be first field in struct si_info.

Gr. AvS

