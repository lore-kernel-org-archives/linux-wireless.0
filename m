Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12790 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbaCNJDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 05:03:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ben@decadent.org.uk>
CC: <linux-wireless@vger.kernel.org>, <dwmw2@infradead.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: add firmware files
References: <20140314084501.23100.13103.stgit@x230>
	<20140314084514.23100.72654.stgit@x230>
Date: Fri, 14 Mar 2014 11:03:01 +0200
In-Reply-To: <20140314084514.23100.72654.stgit@x230> (Kalle Valo's message of
	"Fri, 14 Mar 2014 10:45:14 +0200")
Message-ID: <87wqfx8856.fsf@kamboji.qca.qualcomm.com> (sfid-20140314_100314_675902_20CDCBCF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Add firmware files for ath10k wireless driver with the new QCA license.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  LICENCE.qca                         |   44 +++++++++++++++++++++++++++++++++++
>  WHENCE                              |    9 +++++++
>  ath10k/QCA988X/hw2.0/board.bin      |  Bin
>  ath10k/QCA988X/hw2.0/firmware-2.bin |  Bin
>  4 files changed, 53 insertions(+)

I forgot to mention in the commit log that the version of this firmware
is 10.1.467.2-1.

-- 
Kalle Valo
