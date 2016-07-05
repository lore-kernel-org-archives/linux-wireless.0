Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35133 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbcGEOcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 10:32:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] rtlwifi: Remove unused parameter from rtl_ps_set_rf_state()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466879867-2499-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Message-Id: <20160705143210.081C0611CF@smtp.codeaurora.org> (sfid-20160705_163215_584097_EFB6E2D4)
Date: Tue,  5 Jul 2016 14:32:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Commit 4b9d8d67b44a ("rtlwifi: rtl8192cu: Remove unused parameter") reworked
> this routine. Those changes were later reverted by commit d3feae41a347
> ("rtlwifi: Update power-save routines for 062814 driver").
> 
> There were two changes in commit 4b9d8d67b44a. The first of these removed
> a parameter from rtl_ps_set_rf_state() that was always false. This is the
> change that is restored in the current patch. A second change that reworked
> the locking is still being analyzed.
> 
> In addition to removing the unused parameter, there is no need for
> rtl_ps_set_rf_state() to be exported.
> 
> Reported-by: Pavel Andrianov <andrianov@ispras.ru>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pavel Andrianov <andrianov@ispras.ru>

Thanks, 6 patches applied to wireless-drivers-next.git:

30462b514fb3 rtlwifi: Remove unused parameter from rtl_ps_set_rf_state()
204e2ab22e1e rtlwifi: rtl8188ee: Fix potential race condition
c3ae8ec4a264 rtlwifi: rtl8192ee: Fix potential race condition
31c2e76c77fb rtlwifi: rtl8723be: Fix potential race condition
4f29b348bdc0 rtlwifi: rtl8723ae: Fix potential race condition
300c32ca84f5 rtlwifi: rtl8821ae: Fix potential race condition

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9198637/

