Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3468 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbYA3QcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 11:32:16 -0500
Date: Wed, 30 Jan 2008 11:11:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] NET: constify data and function pointer tables
Message-ID: <20080130161113.GB3317@tuxdriver.com> (sfid-20080130_163220_283761_0928A2BC)
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801222046170.5722@fbirervta.pbzchgretzou.qr> <47A0427D.7040301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47A0427D.7040301@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 30, 2008 at 04:25:17AM -0500, Jeff Garzik wrote:
> Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>> ---
>>  drivers/net/bonding/bond_main.c         |    2 +-
>>  drivers/net/hamradio/bpqether.c         |    2 +-
>>  drivers/net/hamradio/scc.c              |    2 +-
>>  drivers/net/hamradio/yam.c              |    2 +-
>>  drivers/net/ibmveth.c                   |    2 +-
>>  drivers/net/pppoe.c                     |    2 +-
>>  drivers/net/pppol2tp.c                  |    4 ++--
>>  drivers/net/wireless/libertas/debugfs.c |   14 +++++++-------
>>  drivers/net/wireless/strip.c            |    2 +-
>>  9 files changed, 16 insertions(+), 16 deletions(-)
>
> ACK -- but you should collect linville's ack of the wireless stuff too 
> (even though the patch is simple and obvious)

Looks fine to me...ACK

-- 
John W. Linville
linville@tuxdriver.com
