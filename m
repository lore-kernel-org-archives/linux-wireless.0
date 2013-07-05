Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37515 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab3GENge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:36:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [patch] ath10k: off by one sanity check
References: <20130618072846.GC12329@elgon.mountain>
Date: Fri, 5 Jul 2013 16:36:25 +0300
In-Reply-To: <20130618072846.GC12329@elgon.mountain> (Dan Carpenter's message
	of "Tue, 18 Jun 2013 10:28:46 +0300")
Message-ID: <87txk9f7s6.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_153638_403821_3E8E2FB5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> This should be >= ARRAY_SIZE() instead of > ARRAY_SIZE().
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for the patch. John already applied this to his wireless-next
tree.

-- 
Kalle Valo
