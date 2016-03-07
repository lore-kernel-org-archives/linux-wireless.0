Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50255 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcCGMYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:24:40 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: at76c50x-usb: avoid double usb_put_dev() after downloading
 internalfirmware in at76_probe()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456007429-4713-2-git-send-email-khoroshilov@ispras.ru>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Message-Id: <20160307122439.DB0F860897@smtp.codeaurora.org> (sfid-20160307_132453_806799_DD4878A2)
Date: Mon,  7 Mar 2016 12:24:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> There is no need in usb_put_dev() if at76_load_internal_fw() succeed.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
