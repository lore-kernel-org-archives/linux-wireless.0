Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59162 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbcFPPXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:23:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] b43: Remove unused phy_a code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465052053-26740-1-git-send-email-linux@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org, m@bues.ch,
	Guenter Roeck <linux@roeck-us.net>
Message-Id: <20160616152337.3C1BE61418@smtp.codeaurora.org> (sfid-20160616_172358_223026_65611F0E)
Date: Thu, 16 Jun 2016 15:23:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guenter Roeck <linux@roeck-us.net> wrote:
> gcc-6 reports the following error with -Werror=unused-const-variable.
> 
> drivers/net/wireless/broadcom/b43/phy_a.c:576:40: error:
> 	'b43_phyops_a' defined but not used
> 
> Per Michael Büsch: "All a-phy code is usused", so remove it all,
> and move the remaining Type-G initialization code into phy_g.c.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> Cc: Michael Büsch <m@bues.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Thanks, 2 patches applied to wireless-drivers-next.git:

9791333a840f b43: Remove unused phy_a code
afdfdc481ea9 b43: Completely remove support for phy_a

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9154719/

