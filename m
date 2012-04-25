Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2DYG1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:27:17 -0400
Message-ID: <4F97993F.3080606@qca.qualcomm.com> (sfid-20120425_082726_337759_66A28B7E)
Date: Wed, 25 Apr 2012 09:27:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Don't advertise HT capability for incapable firmware
References: <1335171233-23814-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1335171233-23814-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2012 11:53 AM, Vasanthakumar Thiagarajan wrote:
> With firmwares which do not support rsn capability override
> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) from host would
> cause 4-way handshake failure when HT cap is advertised.
> To fix this, do not advertise HT cap with cfg80211 for
> those fw.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

This conflicts which Thomas' changes in the same area. Care to rebase
your patches? I think the patch will become pretty simple after the
rebase but I didn't dare to do it myself :)

Kalle
