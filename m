Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7069 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbcDSPr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 11:47:56 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [patch v2] ath10k: add some sanity checks
Date: Tue, 19 Apr 2016 15:47:53 +0000
Message-ID: <87vb3diore.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_174807_245123_1BA32C07)
References: <20160411081520.GA17911@mwanda>
In-Reply-To: <20160411081520.GA17911@mwanda> (Dan Carpenter's message of "Mon,
	11 Apr 2016 11:15:20 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Smatch complains that since "ev->peer_id" comes from skb->data that
> means we can't trust it and have to do a bounds check on it to prevent
> an array overflow.
>
> Fixes: 6942726f7f7b ('ath10k: add fast peer_map lookup')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.

-- 
Kalle Valo