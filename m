Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37461 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbbLHO5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:57:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Steve deRosier <derosier@gmail.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: Re: [PATCH] ath6kl: Don't print error message when recv is canceled
References: <1447887088-19018-1-git-send-email-steve.derosier@lairdtech.com>
Date: Tue, 08 Dec 2015 16:56:56 +0200
In-Reply-To: <1447887088-19018-1-git-send-email-steve.derosier@lairdtech.com>
	(Steve deRosier's message of "Wed, 18 Nov 2015 14:51:28 -0800")
Message-ID: <87k2op9efb.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155725_213913_294D3305)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> An error message ath6kl_htc_rxmsg_pending_handler isn't appropate for when
> the error is ECANCELED. This could be the result of a perfectly appropriate
> RX cancel due to shutdown or suspend. This allows the right cleanup to
> continue, but without an alarming error message in this particular case.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

Applied, thanks.

-- 
Kalle Valo
