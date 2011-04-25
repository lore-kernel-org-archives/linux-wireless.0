Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab1DYRnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:43:08 -0400
Date: Mon, 25 Apr 2011 10:38:34 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Felix Fietkau <nbd@openwrt.org>,
	ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	stable@kernel.org
Subject: Re: [stable] ath9k: Regression in 2.6.38 (30% package losses,
 ~20KBit/s throughput) with AR9285
Message-ID: <20110425173834.GC32065@kroah.com> (sfid-20110425_194312_447813_6FB5C1FF)
References: <4DB56E5B.4090101@hauke-m.de>
 <4DB57180.40208@hauke-m.de>
 <20110425170750.GB28814@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110425170750.GB28814@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 01:07:51PM -0400, John W. Linville wrote:
> You can send stuff to stable yourself.  The main rule is that it is
> already in Linus's tree...
> 
> Stable folks, please apply 115dad7a7f42e68840392767323ceb9306dbdb36
> for the 2.6.38.y tree.

Now queued up.

thanks,

greg k-h
