Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59219 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbcFNOTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:19:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] mwifiex: illegal assignment
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463526118-11822-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Cathy Luo <cluo@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-Id: <20160614141950.158DC61404@smtp.codeaurora.org> (sfid-20160614_162018_603079_4752EE05)
Date: Tue, 14 Jun 2016 14:19:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> Variable adapter is incorrectly initialized.
> 
> Fixes: bf00dc22bc7a ("mwifiex: AMSDU Rx frame handling in AP mode")
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

3fdbda446fbc mwifiex: illegal assignment

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9115501/

