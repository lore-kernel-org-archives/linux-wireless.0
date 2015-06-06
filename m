Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33907 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbbFFMmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 08:42:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2 1/3] rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
References: <1433588234-27248-1-git-send-email-ap420073@gmail.com>
Date: Sat, 06 Jun 2015 15:42:04 +0300
In-Reply-To: <1433588234-27248-1-git-send-email-ap420073@gmail.com> (Taehee
	Yoo's message of "Sat, 6 Jun 2015 19:57:14 +0900")
Message-ID: <87k2vhnh43.fsf@kamboji.qca.qualcomm.com> (sfid-20150606_144636_524975_24E9FD81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

> in the _rtl92c_phy_rf6052_config_parafile(), cases
> RF90_PATH_A and RF90_PATH_B call the same routine.
> so i remove one of these routine. also the return
> routine is duplicated. so i remove it.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Please resend the whole series (ie. all three patches), not just the
patch which has changed.

-- 
Kalle Valo
