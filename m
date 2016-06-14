Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59443 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbcFNOVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:21:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] mwiflex: avoid possible null pointer dereference
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463526961-12019-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-Id: <20160614142144.D65D061381@smtp.codeaurora.org> (sfid-20160614_162209_383844_ABCE940C)
Date: Tue, 14 Jun 2016 14:21:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> Do not dereference card before checking against NULL value.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

141bcf099076 mwiflex: avoid possible null pointer dereference

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9115521/

