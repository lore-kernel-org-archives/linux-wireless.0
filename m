Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34280 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbcFJTyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 15:54:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Shengzhen Li <szli@marvell.com>,
	Enric Balletbo i Serra <enric.balletbo@collabora.com>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH v2 2/3] mwifiex: move .get_tx_power logic to station ioctl file
References: <1465232558-31678-1-git-send-email-javier@osg.samsung.com>
	<1465232558-31678-3-git-send-email-javier@osg.samsung.com>
	<87wplxdsln.fsf@kamboji.qca.qualcomm.com>
	<12ccd90e-e3eb-ecac-b23f-8124b0db32ad@osg.samsung.com>
	<2b5e5833ecc74a2b9cd822e8455cd0af@SC-EXCH04.marvell.com>
	<8dc6e64a-3429-4bed-e5c9-da6880eb9505@osg.samsung.com>
Date: Fri, 10 Jun 2016 22:54:10 +0300
In-Reply-To: <8dc6e64a-3429-4bed-e5c9-da6880eb9505@osg.samsung.com> (Javier
	Martinez Canillas's message of "Fri, 10 Jun 2016 15:33:45 -0400")
Message-ID: <87shwkes65.fsf@kamboji.qca.qualcomm.com> (sfid-20160610_215443_171923_59F9205B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Martinez Canillas <javier@osg.samsung.com> writes:

>> This patch (2/3) is only for code rearrangement and adds an
>> unnecessary wrapper function. We can simply drop the patch.
>
> Agreed.
>
> Kalle,
>
> Patch 3/3 applies cleanly even after dropping patch 2/3.
> Is that Ok for you or do you want me to re-resend a v3
> with only patches 1/3 and 3/3?

I can drop patch 2, no need to resend. Thanks.

-- 
Kalle Valo
