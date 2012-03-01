Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2CAGdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:33:00 -0500
Message-ID: <4F4F1817.9070904@qca.qualcomm.com> (sfid-20120301_073330_616189_F595A773)
Date: Thu, 1 Mar 2012 08:32:55 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V3 1/5] ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
References: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 04:50 PM, Vasanthakumar Thiagarajan wrote:
> There are some code which initializes various wiphy members
> left outside ath6kl_cfg80211_init(), in ath6kl_core_init().
> Move them into a single palce.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, all five patches applied.

Kalle
