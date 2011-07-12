Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:60552 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1GLU7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 16:59:49 -0400
Date: Tue, 12 Jul 2011 22:59:48 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Felix Fietkau <nbd@openwrt.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH v2 07/46] net/wireless: ath9k: fix DMA
 API usage
Message-ID: <20110712205948.GA14399@rere.qmqm.pl> (sfid-20110712_225956_881664_9C925999)
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl>
 <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl>
 <4E1BCF36.2010506@openwrt.org>
 <20110712193204.GB13413@linux-mips.org>
 <20110712205316.GA13503@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20110712205316.GA13503@rere.qmqm.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2011 at 10:53:16PM +0200, Micha³ Miros³aw wrote:
> In the case we're analysing, the ownership is on the device's side
> until it stops writing the buffer.

Just to be clear, this should say: ... until it marks the buffer as done.

Best Regards,
Micha³ Miros³aw
