Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45324 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2BBIOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 03:14:12 -0500
Message-ID: <4F2A45CF.1070203@qca.qualcomm.com> (sfid-20120202_091415_375198_EC37D351)
Date: Thu, 2 Feb 2012 10:14:07 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix compiler warning in ath6kl_init_hw_params()
References: <20120131192622.12404.74061.stgit@localhost6.localdomain6>
In-Reply-To: <20120131192622.12404.74061.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2012 09:26 PM, Kalle Valo wrote:
> Both Luis and John reported that they see a compiler warning:
> 
> drivers/net/wireless/ath/ath6kl/init.c: In function 'ath6kl_init_hw_params':
> drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’
> may be used uninitialized in this function
> 
> Oddly enough I have never seen it. But AFAICT the code is correct and
> hw is not used uninitalized so add uninitialized_var() to inform that to
> the compiler.
> 
> Reported-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> Reported-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
