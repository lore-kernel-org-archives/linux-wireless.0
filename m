Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49297 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbcCGMNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:13:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Change long delays to sleeps
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160307121331.CF86C6089F@smtp.codeaurora.org> (sfid-20160307_131335_182639_A66E6008)
Date: Mon,  7 Mar 2016 12:13:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Routine rtl_addr_delay() uses delay statements in code that can
> sleep. To improve system responsiveness, the various delay statements
> are changed.
> 
> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
> rewritten to use the code in rtl_addr_delay() for most of their
> input values.
> 
> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
