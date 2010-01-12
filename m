Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0ALSEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 13:04:40 -0500
Date: Tue, 12 Jan 2010 13:04:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	alainswb <alainswb@free.fr>, dev@moblin.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Moblin Dev] Wireless is keep on disconnecting
Message-ID: <20100112180438.GA17003@infradead.org>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com> <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com> <4B4C8320.8060801@free.fr> <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com> <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com> <995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com> <995709e41001120915h1a156606m837717ffd584fa3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <995709e41001120915h1a156606m837717ffd584fa3e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 10:45:29PM +0530, Jaswinder Singh Rajput wrote:
> Sorry here is dmesg.

FYI: since 2.6.32 I also see very frequent disconnects with the no probe
response messages.  This is with an Intel 5100 card, and can be better
or worse depending on the AP.  On my home one it makes the kernel
completely unusable.

