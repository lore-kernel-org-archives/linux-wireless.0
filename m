Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42119 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbbJ1S40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 14:56:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: orinoco_usb: return error in ezusb_probe when alloc_orinocodev
 fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445267700-21554-1-git-send-email-linville@tuxdriver.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	RUC_Soft_Sec <rucsoftsec@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <20151028185626.40EE514152B@smtp.codeaurora.org> (sfid-20151028_195633_286981_8DCB690E)
Date: Wed, 28 Oct 2015 18:56:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The current code exits after alloc_orinocodev, but fails to change the
> return value to something that indicates the failure.  This patch
> changes the return value to -ENOMEM.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=106181
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
