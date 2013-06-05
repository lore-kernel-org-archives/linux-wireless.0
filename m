Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37288 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab3FEI2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:28:09 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] brcmsmac: disable power-save related functions
References: <1370419185-3977-1-git-send-email-arend@broadcom.com>
Date: Wed, 05 Jun 2013 11:28:02 +0300
In-Reply-To: <1370419185-3977-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 5 Jun 2013 09:59:45 +0200")
Message-ID: <878v2p3qst.fsf@purkki.adurom.net> (sfid-20130605_102839_757986_C466E75B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> This patch fixes a regression introduced by:
>
>   commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
>   Author: Hauke Mehrtens <hauke@hauke-m.de>
>   Date:   Sun Mar 24 01:45:52 2013 +0100
>
>       brcmsmac: remove brcms_bss_cfg->associated
>
> The regression behaviour is described in:
>
> http://www.spinics.net/lists/linux-wireless/msg107474.html

The link is not a very reliable reference, it can die anytime and
there's no way to know what message it refers to. Stating the message id
would better. And the best would be to copy the full text to the commit
log, it's only few lines anyway.

-- 
Kalle Valo
