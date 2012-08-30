Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2H3J1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 05:27:53 -0400
Message-ID: <503F3214.6050507@qca.qualcomm.com> (sfid-20120830_112757_286856_F8F308B9)
Date: Thu, 30 Aug 2012 12:27:48 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/4] ath6kl: Refactor ath6kl_init_hw_start() and ath6kl_init_hw_stop()
References: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2012 05:10 PM, Vasanthakumar Thiagarajan wrote:
> So that these functions will be used to re-initialize the fw
> upon detecting fw error. This refactoring moves ar->state
> setting out of core stop/start functionality.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, all four patches applied.

I had to fix one parenthesis alignment in patch 3, but that was easy to do.

Kalle
