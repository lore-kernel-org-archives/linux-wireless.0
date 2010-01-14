Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4435 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab0ANUY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 15:24:56 -0500
Subject: Re: [ath9k-devel] [Moblin Dev] Wireless is keep on disconnecting
From: Pavel Roskin <proski@gnu.org>
To: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"arjan@linux.intel.com" <arjan@linux.intel.com>,
	"Li, Yan" <yan.i.li@intel.com>, "dev@moblin.org" <dev@moblin.org>,
	alainswb <alainswb@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
In-Reply-To: <995709e41001141215k76582249sc4761bdc13d94bb4@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	 <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	 <4B4C8320.8060801@free.fr>
	 <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	 <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
	 <995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
	 <43e72e891001120918v70c3be7nd3d3819f0e8b0cd0@mail.gmail.com>
	 <995709e41001122307g2d0e9546g2b3680a6cb0a345d@mail.gmail.com>
	 <20100113160942.GB15698@tux>
	 <995709e41001141215k76582249sc4761bdc13d94bb4@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 15:24:45 -0500
Message-Id: <1263500685.11457.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-15 at 01:45 +0530, Jaswinder Singh Rajput wrote:

> With wireless-testing I am getting oops. I am attaching it picture.

I reported it yesterday and Sujith sent a patch for that.  Please see
"ath9k: Fix panic on driver load" in the list archives.

If sending images, please try to compress them.  At lease please make
them greyscale.  It's in the moderation queue, and I'm going to reject
it to save bandwidth of the subscribers.

-- 
Regards,
Pavel Roskin
