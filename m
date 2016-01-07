Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34911 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcAGNFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:05:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
References: <20151219105919.GB3749@mwanda>
Date: Thu, 07 Jan 2016 15:05:13 +0200
In-Reply-To: <20151219105919.GB3749@mwanda> (Dan Carpenter's message of "Sat,
	19 Dec 2015 13:59:19 +0300")
Message-ID: <87wprlk0ae.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_140524_873354_7C71C2EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> There is a type bug so it always returns success.
>
> Fixes: 6fa658fd5ab2 ('ath9k: Simplify and fix eeprom endianness swapping')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
