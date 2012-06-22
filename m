Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11600 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762774Ab2FVXga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 19:36:30 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20453.302.671438.533390@gargle.gargle.HOWL> (sfid-20120623_013648_924329_C0BDBE71)
Date: Sat, 23 Jun 2012 05:05:10 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: pull request: wireless 2012-06-22
In-Reply-To: <20452.64701.760819.559191@gargle.gargle.HOWL>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> John W. Linville wrote:
> > Mohammed Shafi Shajakhan (1):
> >       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
> 
> Um, this commit doesn't really fix anything - the timeout is also
> arbitrary. Can you remove this from the 3.5 queue ? Thanks.

A review of the patch later, I think it's good. At least there's a
WARN_ON_ONCE() to indicate the situation in which the measurement fails.
It might come in handy as a debugging aid.

Sujith
