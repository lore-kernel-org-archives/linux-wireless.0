Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40424 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbcGRTh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:37:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2,
 v4] wlcore/wl18xx: Add functionality to accept TX rate per link
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160711142251.30443-1-maxim.altshul@ti.com>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-kernel@vger.kernel.org>,
	Maxim Altshul <maxim.altshul@ti.com>,
	Eliad Peller <eliad@wizery.com>, Guy Mishol <guym@ti.com>,
	"Machani, Yaniv" <yanivma@ti.com>, Arik Nemtsov <arik@wizery.com>,
	<linux-wireless@vger.kernel.org>
Message-Id: <20160718193758.D6FDB6037B@smtp.codeaurora.org> (sfid-20160718_213803_362796_2C8EA208)
Date: Mon, 18 Jul 2016 19:37:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> wrote:
> FW will provide a TX rate per link for each FW status,
> and wlcore will be able to store the information for
> the use of the mesh hwmp module.
> 
> This is used mainly in mesh.
> Rates are reported when a mesh interface is up.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

88f07e70d1be wlcore/wl18xx: Add functionality to accept TX rate per link
5634723758a1 wlcore: Add support for get_expected_throughput opcode

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9223705/

