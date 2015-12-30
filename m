Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41655 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbL3Pgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 10:36:35 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl_pci: Fix kernel panic
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1450739108-24121-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20151230153635.2E8E460222@smtp.codeaurora.org> (sfid-20151230_163639_698969_42A7E697)
Date: Wed, 30 Dec 2015 15:36:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In commit 38506ecefab9 (rtlwifi: rtl_pci: Start modification for new
> drivers), a bug was introduced that causes a NULL pointer dereference.
> As this bug only affects the infrequently used RTL8192EE and only under
> low-memory conditions, it has taken a long time for the bug to show up.
> 
> The bug was reported on the linux-wireless mailing list and also at
> https://bugs.launchpad.net/ubuntu/+source/ubuntu-release-upgrader/ as
> bug #1527603 (kernel crashes due to rtl8192ee driver on ubuntu 15.10).
> 
> Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
