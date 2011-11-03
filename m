Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51860 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175Ab1KCRAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:00:14 -0400
Message-ID: <4EB2C83E.8000205@qca.qualcomm.com> (sfid-20111103_180020_839194_AA33F898)
Date: Thu, 3 Nov 2011 18:58:38 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: add suspend_cutpower module parameter
References: <20111103101831.15206.39020.stgit@localhost6.localdomain6>
In-Reply-To: <20111103101831.15206.39020.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 12:18 PM, Kalle Valo wrote:
> This is to force ath6kl to power off hardware during suspend even if
> sdio support keep power. This is needed, for example, when sdio
> controller is buggy or maximum powersaving is desired.
> 
> Usage:
> 
> insmod ath6kl.ko suspend_cutpower=1

Applied.

Kalle
