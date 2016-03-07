Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50408 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbcCGMZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:25:58 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2] rtlwifi: pass struct rtl_stats by reference as it is
 moreefficient
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456140946-12509-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160307122556.D5EFC6060D@smtp.codeaurora.org> (sfid-20160307_132606_942369_48589645)
Date: Mon,  7 Mar 2016 12:25:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Colin Ian King <colin.king@canonical.com>
> 
> passing rtl_stats by value is inefficient; the structure is over 300
> bytes in size and generally just one field (packet_report_type)
> is being accessed, so the pass by value is a relatively large overhead.
> This change just affects just the rx_command_packet calls.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
