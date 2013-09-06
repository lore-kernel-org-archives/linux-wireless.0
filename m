Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3IFJcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 05:32:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dave Jones <davej@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] Add missing braces to ath10k_pci_tx_pipe_cleanup
References: <20130905035128.GA15824@redhat.com>
Date: Fri, 6 Sep 2013 12:32:43 +0300
In-Reply-To: <20130905035128.GA15824@redhat.com> (Dave Jones's message of
	"Wed, 4 Sep 2013 23:51:28 -0400")
Message-ID: <87mwnqi9c4.fsf@kamboji.qca.qualcomm.com> (sfid-20130906_113259_793256_25185933)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Jones <davej@redhat.com> writes:

> The indentation here implies this was meant to be a multi-statement
> if, but it lacks the braces.
>
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Thanks, applied.

I added "ath10k:" to the patch title.

-- 
Kalle Valo
