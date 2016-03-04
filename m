Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45722 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbcCDIlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:41:20 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Anton Protopopov <a.s.protopopov@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix erroneous return value
Date: Fri, 4 Mar 2016 08:41:15 +0000
Message-ID: <8760x2zlcn.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094148_588978_8FD67BE6)
References: <1455123535-26751-1-git-send-email-a.s.protopopov@gmail.com>
In-Reply-To: <1455123535-26751-1-git-send-email-a.s.protopopov@gmail.com>
	(Anton Protopopov's message of "Wed, 10 Feb 2016 11:58:55 -0500")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anton Protopopov <a.s.protopopov@gmail.com> writes:

> The ath10k_pci_hif_exchange_bmi_msg() function may return the positive
> value EIO instead of -EIO in case of error.
>
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>

Applied, thanks.

-- 
Kalle Valo