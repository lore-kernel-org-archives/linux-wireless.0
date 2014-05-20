Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:51988 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaETINy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:13:54 -0400
Message-ID: <537B0EBD.5080900@broadcom.com> (sfid-20140520_101359_397788_D01844BA)
Date: Tue, 20 May 2014 10:13:49 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] cfg80211: constify MAC addresses in cfg80211 ops
References: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/14 17:54, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> This propagates through all the drivers and mac80211.
>
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---

Should this also be done for the macaddr field in struct vif_params?

Regards,
Arend
