Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48518 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbcCGMAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:00:07 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Silence useless log output
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1455209782-12985-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160307120006.CEDB3608A0@smtp.codeaurora.org> (sfid-20160307_130011_175271_534FA227)
Date: Mon,  7 Mar 2016 12:00:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When driver rtl8821ae is loaded but not connected to any AP, it logs
> a "firmware not ready to run" message roughly once a minute. To
> eliminate logging this massage under normal debug conditions, the
> degug level needed to print this message is increased.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
