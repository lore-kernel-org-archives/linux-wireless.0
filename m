Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51205 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3CEHxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 02:53:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [patch] ath6kl: small cleanup in ath6kl_htc_pipe_rx_complete()
References: <20130228044547.GC15239@longonot.mountain>
Date: Tue, 5 Mar 2013 09:53:29 +0200
In-Reply-To: <20130228044547.GC15239@longonot.mountain> (Dan Carpenter's
	message of "Thu, 28 Feb 2013 07:45:47 +0300")
Message-ID: <874ngqgu4m.fsf@kamboji.qca.qualcomm.com> (sfid-20130305_085352_233260_FCA9BC94)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> It's harmless, but Smatch complains if we use "htc_hdr->eid" before
> doing the bounds check.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

-- 
Kalle Valo
