Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58364 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbcD0Nwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 09:52:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: fix coding style
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461251276-14891-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160427135241.5B622612F0@smtp.codeaurora.org> (sfid-20160427_155246_637004_7F18A1A3)
Date: Wed, 27 Apr 2016 13:52:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Redundant space in case statement is removed.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

3f210e2f1269 mwifiex: fix coding style
df2288623ee0 mwifiex: report wowlan wakeup reasons correctly
d286af9bf40a mwifiex: avoid querying wakeup reason when wowlan is disabled

Kalle Valo
