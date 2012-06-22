Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FVXR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 19:17:26 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20452.64701.760819.559191@gargle.gargle.HOWL> (sfid-20120623_011756_819638_3F715BEB)
Date: Sat, 23 Jun 2012 04:46:13 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: pull request: wireless 2012-06-22
In-Reply-To: <20120622201716.GB13918@tuxdriver.com>
References: <20120622201716.GB13918@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Mohammed Shafi Shajakhan (1):
>       ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

Um, this commit doesn't really fix anything - the timeout is also
arbitrary. Can you remove this from the 3.5 queue ? Thanks.

Sujith
