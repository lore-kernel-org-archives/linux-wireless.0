Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1ISHFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 03:05:07 -0400
Message-ID: <4E76E99E.6090607@qca.qualcomm.com> (sfid-20110919_090511_678571_07C0D765)
Date: Mon, 19 Sep 2011 10:05:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: deinitialise wiphy on error
References: <1316098843-6660-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1316098843-6660-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2011 06:00 PM, Vivek Natarajan wrote:
> This fixes the following panic observed on card removal.
> 
> BUG: unable to handle kernel paging request at f86e22ac
> EIP is at wiphy_update_regulatory+0x252/0x590 [cfg80211]
> Call Trace:
>  [<f92fb9e5>] set_regdom+0x165/0x600 [cfg80211]
>  [<c02057ba>] ? __kmalloc+0x10a/0x190
>  [<c0366557>] ? nla_parse+0xb7/0xd0
>  [<f9300b92>] ? T.1400+0x12/0x20 [cfg80211]
>  [<f9300c84>] nl80211_set_reg+0xe4/0x270 [cfg80211]
>  [<f92fe560>] ? nl80211_pre_doit+0x0/0x160 [cfg80211]
>  [<c050bdeb>] genl_rcv_msg+0x23b/0x280
>  [<c050bbb0>] ? genl_rcv_msg+0x0/0x280
>  [<c050ab76>] netlink_rcv_skb+0x86/0xb0
>  [<c050bb80>] ? genl_rcv+0x0/0x30
>  [<c050bb9c>] genl_rcv+0x1c/0x30

Thanks, applied.

Kalle
