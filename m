Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27737 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbbKDRyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 12:54:05 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath10k: add QCA9377 hw1.0 support
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
	<1446638015-23310-5-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 4 Nov 2015 19:53:45 +0200
In-Reply-To: <1446638015-23310-5-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 4 Nov 2015 12:53:35 +0100")
Message-ID: <87lhadbqhi.fsf@kamboji.qca.qualcomm.com> (sfid-20151104_185411_257134_05F3D82D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Add new BMI target version and chip id revision. Register it
> on supported chips list.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

This one has whitespace issues:

drivers/net/wireless/ath/ath10k/core.c:163: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:163: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:164: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:164: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:165: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:165: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:166: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:166: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:167: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:167: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:168: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:168: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:169: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:169: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:170: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:170: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:171: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:171: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/core.c:172: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/core.c:172: please, no spaces at the start of a line


-- 
Kalle Valo
