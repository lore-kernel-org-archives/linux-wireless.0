Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4667 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2FMJqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:46:49 -0400
Message-ID: <4FD85FE3.3090604@broadcom.com> (sfid-20120613_114652_433799_1888C972)
Date: Wed, 13 Jun 2012 11:39:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 7/9] brcm80211: smac: use mac80211 channel data
 for tx power limits
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-8-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1338906849-26135-8-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 04:34 PM, Seth Forshee wrote:
> Currently the limits from the internal X2 domain are used, regardless
> of what regulatory rules are in effect. Instead use the power limits set
> by the higher-level regulatory support.
> 
> The rules for the MIMO power limits are still always derived from the
> world domain. Guidance from Broadcom is needed on how these limits
> should be determined for other regulatory domains.

Have not got definite answer yet. Luis indicated that Qualcomm/Atheros
had similar construct, but that is was not really needed and could be
derived. I will have to follow up on it in a separate patch.

> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c |   73 ++++-----------------
>  1 file changed, 14 insertions(+), 59 deletions(-)

Gr. AvS

