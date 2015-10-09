Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37678 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722AbbJIItM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:49:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Geliang Tang <geliangtang@163.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath6kl: drop unlikely behind WARN_ON()
References: <61de1b17c432479ccded41edfb553e2d20ebf8ae.1444048783.git.geliangtang@163.com>
Date: Fri, 09 Oct 2015 11:49:02 +0300
In-Reply-To: <61de1b17c432479ccded41edfb553e2d20ebf8ae.1444048783.git.geliangtang@163.com>
	(Geliang Tang's message of "Mon, 5 Oct 2015 20:46:12 +0800")
Message-ID: <87vbagqvep.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_104940_917916_9F7AA381)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@163.com> writes:

> WARN_ON() already contain an unlikely compiler flag. Drop it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Applied, thanks.

-- 
Kalle Valo
