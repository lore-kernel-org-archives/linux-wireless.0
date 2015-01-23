Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbbAWRD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:03:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: check driver status in connect and scan handlers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1420631859-29004-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150123170327.4E86214125D@smtp.codeaurora.org> (sfid-20150123_180350_036823_7A604121)
Date: Fri, 23 Jan 2015 17:03:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Ignore scan and connection requests from cfg80211 when driver
> unload is in process or previous command has timed out due to
> a firmware bug. This patch fixes corner case system crash
> issues.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
