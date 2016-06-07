Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33466 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbcFGRMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 13:12:01 -0400
Date: Tue, 7 Jun 2016 22:41:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	marek.lindner@open-mesh.com
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Message-ID: <20160607171110.GA13293@atheros-ThinkPad-T61> (sfid-20160607_191206_386532_8D5A667E)
References: <1568876.Six5hABE57@bentobox>
 <2262792.6VVL0Htyzj@bentobox>
 <20160607145002.GB11250@atheros-ThinkPad-T61>
 <2104766.hdzL6bzVNd@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2104766.hdzL6bzVNd@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Tue, Jun 07, 2016 at 06:54:54PM +0200, Sven Eckelmann wrote:
> On Tuesday 07 June 2016 20:20:02 Mohammed Shafi Shajakhan wrote:
> [...]
> > [shafi] it would be helpful if you can share your basic test results (if its
> > possible to share). Have you tried to bring up the card in 5ghz (or) 2ghz.
> > Or both of them were tried ?
> 
> * 5GHz-only (I have no 2.4GHz capable card)
> * card is able to scan
> * card is able to create an AP
> * data can be transferred via AP and client (bidirectional connection)
> * performance was more like 15 Mibit/s for 1x1 HT20 11n devices instead of
>   something like 35-40 Mibit/s

[shafi] sure thanks a lot, this is a good start, i will keep you posted
with my findings and results.

> 
> I cannot give you any more detailed, current performance test results because
> they were done months ago and are most likely not relevant to describe the
> current state. Please ask Kalle if you want to know why the old tests were
> done many, many months ago.

[shafi] sure, hopefully we can get this sorted out. Thank you for the patches
and support.

> 
> Please ask Marek when you want to have tests done with the current
> mac8011+ath10k.

[shafi] thanks

> 
> Kind regards,
> 	Sven


