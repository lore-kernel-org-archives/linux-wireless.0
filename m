Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58595 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbcFBNOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 09:14:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"leroi.lists@gmail.com" <leroi.lists@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] ath10k: disable wake_tx_queue for older devices
Date: Thu, 2 Jun 2016 13:14:27 +0000
Message-ID: <87inxrzqa5.fsf@kamboji.qca.qualcomm.com> (sfid-20160602_151437_379955_82D1D760)
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 17 May 2016 14:47:01 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some setups suffer performance regressions with
> current wake_tx_queue implementation.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> Hi Roman,
>
> Can you give this patch a try and see if it helps
> with your performance problems, please?

Did anyone seeing the performance regression manage to test this? It
would be good to get feedback, good or bad, before I push this to 4.7.

Full patch here:

https://patchwork.kernel.org/patch/9111981/

-- 
Kalle Valo