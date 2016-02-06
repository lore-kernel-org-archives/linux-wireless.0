Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53674 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFMAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 07:00:39 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix bandwidth display problem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454312686-31172-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Nachiket Kukade <kukaden@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160206120039.0B841604F6@smtp.codeaurora.org> (sfid-20160206_130042_127907_CEA2C6A4)
Date: Sat,  6 Feb 2016 12:00:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Nachiket Kukade <kukaden@marvell.com>
> 
> Instead of using HT info from beacon IEs, use HT info from
> association response frame to update bandwidth in
> cfg80211_get_channel handler.
> 
> Signed-off-by: Nachiket Kukade <kukaden@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
