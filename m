Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4954 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2FWCMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 22:12:47 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20453.9687.225096.194368@gargle.gargle.HOWL> (sfid-20120623_041346_824570_031DF46F)
Date: Sat, 23 Jun 2012 07:41:35 +0530
To: David Miller <davem@davemloft.net>
CC: <c_manoha@qca.qualcomm.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: pull request: wireless 2012-06-22
In-Reply-To: <20120622.165611.2220193371527786713.davem@davemloft.net>
References: <20120622201716.GB13918@tuxdriver.com>
	<20452.64701.760819.559191@gargle.gargle.HOWL>
	<20453.302.671438.533390@gargle.gargle.HOWL>
	<20120622.165611.2220193371527786713.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Date: Sat, 23 Jun 2012 05:05:10 +0530
> 
> > Sujith Manoharan wrote:
> >> John W. Linville wrote:
> >> > Mohammed Shafi Shajakhan (1):
> >> >       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
> >> 
> >> Um, this commit doesn't really fix anything - the timeout is also
> >> arbitrary. Can you remove this from the 3.5 queue ? Thanks.
> > 
> > A review of the patch later, I think it's good. At least there's a
> > WARN_ON_ONCE() to indicate the situation in which the measurement fails.
> > It might come in handy as a debugging aid.
> 
> Thanks for wasting our time.
> 
> Make these determinations when changes to into John's tree, not
> later when he asks me to pull them into mine.

The patch was under review:
http://marc.info/?l=linux-wireless&m=134001371002288&w=2

Sujith
