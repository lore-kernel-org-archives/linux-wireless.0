Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbbGUPID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:08:03 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore: add antenna diversity reading
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437034967-30374-1-git-send-email-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Guy Mishol <guym@ti.com>
Message-Id: <20150721150802.7AACF141BB5@smtp.codeaurora.org> (sfid-20150721_170807_600628_DE53E7BA)
Date: Tue, 21 Jul 2015 15:08:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> update the rssi reading on rx_status
> to read both RSSI level (7 bits) and
> antenna diversity (msb)
> 
> Signed-off-by: Guy Mishol <guym@ti.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
