Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9848 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcCDIkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:40:55 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix pktlog in QCA99X0
Date: Fri, 4 Mar 2016 08:40:46 +0000
Message-ID: <87a8mezldf.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094058_104154_2BEF8A37)
References: <1454686969-5740-1-git-send-email-arnagara@qti.qualcomm.com>
In-Reply-To: <1454686969-5740-1-git-send-email-arnagara@qti.qualcomm.com>
	(Ashok Raj Nagarajan's message of "Fri, 5 Feb 2016 21:12:48 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> writes:

> Currently, we are providing wrong payload data of pktlog to trace points.
> Data we receive from FW through copy engine 8 contains pktlog data alone.
> We don't need to parse anything in driver before handing it to trace
> points.
>
> Fixes: afb0bf7f530b ("ath10k: add support for pktlog in QCA99X0")
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Both applied, thanks.

-- 
Kalle Valo