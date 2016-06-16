Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57916 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbcFPPOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:14:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas_tf: Drop unused variable and define
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464986935-23361-1-git-send-email-linux@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Message-Id: <20160616151431.5429461372@smtp.codeaurora.org> (sfid-20160616_171451_270653_5C9788CA)
Date: Thu, 16 Jun 2016 15:14:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guenter Roeck <linux@roeck-us.net> wrote:
> gcc-6 reports:
> 
> drivers/net/wireless/marvell/libertas_tf/main.c:30:19: error:
> 	'lbtf_driver_version' defined but not used
> 
> with -Werror=unused-const-variable=.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

035ddbc59f54 libertas_tf: Drop unused variable and define

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9154015/

