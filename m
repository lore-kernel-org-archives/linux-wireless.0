Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21299 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853Ab3IYXNm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 19:13:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 16:13:32 -0700
Subject: RE: [PATCH 09/11] mwifiex: Remove extern from function prototypes
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077E54@SC-VEXCH1.marvell.com> (sfid-20130926_011346_278082_37472DDB)
References: <cover.1380137609.git.joe@perches.com>
 <b3a7cd194857b3dc099e8f8bb0ed97bb4a1b5fde.1380137610.git.joe@perches.com>
In-Reply-To: <b3a7cd194857b3dc099e8f8bb0ed97bb4a1b5fde.1380137610.git.joe@perches.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

Thanks for your patch.

> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/wmm.h | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

