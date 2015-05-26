Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55434 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbEZNR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:17:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [NEXT] rtlwifi: btcoexist: Fix interference between rtl8723be
 andBluetooth
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431370827-13324-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Daniel Drake <drake@endlessm.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Shao Fu <shaofu@realtek.com>
Message-Id: <20150526104948.BE1AA1416A8@smtp.codeaurora.org> (sfid-20150526_151815_321947_BA90F6FD)
Date: Tue, 26 May 2015 10:49:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Daniel Drake <drake@endlessm.com>
> 
> During usage of the new Bluetooth driver for Realtek devices, it was found
> that BT scans were inhibited for the RTL8723BE when wireless was active. The
> exact cause of this interference is not known yet, but a satisfactory work
> around has been found that does not seem to have any visible side effects.
> 
> Signed-off-by: Daniel Drake <drake@endlessm.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Shao Fu <shaofu@realtek.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
