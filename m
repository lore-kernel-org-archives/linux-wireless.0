Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60349 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbcFNOa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:30:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: inform disconnection initiator correctly.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464190655-21667-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160614143058.E5F5B61418@smtp.codeaurora.org> (sfid-20160614_163103_017810_F59E8533)
Date: Tue, 14 Jun 2016 14:30:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> This patch ensures that 'locally_generated' parameter is correctly
> passed to cfg80211_disconnected() API.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

c62d50a4062e mwifiex: inform disconnection initiator correctly.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9135689/

