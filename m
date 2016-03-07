Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56601 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbcCGJs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 04:48:58 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix HTT Tx CE ring size
Date: Mon, 7 Mar 2016 09:48:53 +0000
Message-ID: <87egbmvcsd.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_105845_950875_19D36663)
References: <1456834571-9847-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1456834571-9847-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 1 Mar 2016 13:16:10 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> QCA4019 can queue up to 2500 frames at a time.
> This means it requires roughly 5000 entires on the
> ring to work properly. Otherwise random tx failure
> may occur.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Both patches applied, thanks.

-- 
Kalle Valo