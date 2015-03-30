Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbC3Iaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:30:39 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Change REG_CR+2 to MSR
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426847493-5722-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150330083036.955FD1401B6@smtp.codeaurora.org> (sfid-20150330_103042_434700_DC9F836F)
Date: Mon, 30 Mar 2015 08:30:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I changed REG_CR+2 and (MSR) to MSR because MSR is defined as (REG_CR + 2).
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
