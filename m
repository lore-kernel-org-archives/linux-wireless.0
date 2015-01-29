Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56155 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbA2I0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 03:26:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,
 01/10] mwifiex: do not send regulatory update while starting AP
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422440665-3940-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150129082604.39A6413FF33@smtp.codeaurora.org> (sfid-20150129_092610_386178_D5FCD6C3)
Date: Thu, 29 Jan 2015 08:26:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When regulatory domain changes, cfg80211 already issues request
> to change regulatory domain to driver via reg_notifier.
> There is no need to set regulatory again during start_ap.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 10 patches applied to wireless-drivers-next.git:

6144369f8b4b mwifiex: do not send regulatory update while starting AP
35c739b50d78 mwifiex: store AP configuration in private structure
b0d4c5ec9730 mwifiex: update IEs after AP has started
b654ca182a2f mwifiex: refactor start_ap handler
2ade5667e2e0 mwifiex: separate function for parsing head and tail IEs
85afb18621be mwifiex: add cfg80211 start_radar_detection handler
0a694d68651b mwifiex: support for channel report for radar detection
3b57c1a713a9 mwifiex: handle radar detect event from FW
7d652034d1a0 mwifiex: channel switch support for mwifiex
cf075eac9ca9 mwifiex: 11h handling for AP interface

Kalle Valo
