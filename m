Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21342 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1IVHpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:45:33 -0400
Message-ID: <4E7AE78C.2080509@qca.qualcomm.com> (sfid-20110922_094536_247234_677D132A)
Date: Thu, 22 Sep 2011 10:45:16 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Report PMKSA candidate events through cfg80211
References: <20110921135729.GA26105@jouni.qca.qualcomm.com>
In-Reply-To: <20110921135729.GA26105@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 04:57 PM, Jouni Malinen wrote:
> This allows RSN pre-authentication to be used when roaming decisions are
> done in the target.

Thanks, applied.

A cosmetic comment:

> +		ath6kl_dbg(ATH6KL_DBG_WMI, "truncated neighbor event "
> +			   "(num=%d len=%d)\n", ev->num_neighbors, len);

It's preferred that the format string is all in one line like this
(sorry for thunderbird's formatting):

ath6kl_dbg(ATH6KL_DBG_WMI,
	"truncated neighbor event (num=%d len=%d)\n",
	ev->num_neighbors, len);

Latest checkpatch will allow lines over 80 chars when it's like this.

Kalle
