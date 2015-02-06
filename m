Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38604 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbBFGxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:53:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcm80211: Delete unnecessary checks before two function calls
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <54D275A7.3050701@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <20150206065332.BE03D140D11@smtp.codeaurora.org> (sfid-20150206_075352_881196_192E7F24)
Date: Fri,  6 Feb 2015 06:53:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 4 Feb 2015 20:28:49 +0100
> 
> The functions brcmu_pkt_buf_free_skb() and usb_free_urb() test whether
> their argument is NULL and then return immediately. Thus the test around
> the call is not needed.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
