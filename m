Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound1.eu.mailhop.org ([52.28.251.132]:55003 "EHLO
	outbound1.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbcHIRsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 13:48:31 -0400
Date: Tue, 9 Aug 2016 17:48:24 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: miaoqing@codeaurora.org
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, linux-crypto@vger.kernel.org,
	smueller@chronox.de, pouyans@qti.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Message-ID: <20160809174824.GD2013@io.lakedaemon.net> (sfid-20160809_194835_681406_EA636EF6)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2016 at 03:02:27PM +0800, miaoqing@codeaurora.org wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW
> RNG, disable it by default. But we strongly recommand to enable
> it if the system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Until we get the hw_random/get_device_randomness question sorted...

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
