Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52024 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEINZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:25:54 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] revert "mwifiex: enable aggregation for TID 6 and 7 streams"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1428940945-4123-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150509132553.E910713FF51@smtp.codeaurora.org> (sfid-20150509_153200_347193_3EBF760B)
Date: Sat,  9 May 2015 13:25:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch reverts 'commit c5534844cdee ("mwifiex:
> enable aggregation for TID 6 and 7 streams")'.
> TID6 & TID7 is voice traffic which is quite time sensitive.
> Do not enable any type of aggregation on these TIDs.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

31a09a5d3478 revert "mwifiex: enable aggregation for TID 6 and 7 streams"
9ab7b5b9b160 mwifiex: fix invalid HT IE configuration in FW

Kalle Valo
