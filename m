Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:56761 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab0ANU1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 15:27:21 -0500
Received: by iwn32 with SMTP id 32so35810iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 12:27:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1001140815v5c6dfdc7j62f7d71623490216@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	 <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	 <4B4C8320.8060801@free.fr>
	 <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	 <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
	 <995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
	 <43e72e891001120918v70c3be7nd3d3819f0e8b0cd0@mail.gmail.com>
	 <995709e41001122307g2d0e9546g2b3680a6cb0a345d@mail.gmail.com>
	 <b6c5339f1001140815v5c6dfdc7j62f7d71623490216@mail.gmail.com>
Date: Fri, 15 Jan 2010 01:57:19 +0530
Message-ID: <995709e41001141227n31cab7aeuae0e5a974fa1afdd@mail.gmail.com>
Subject: Re: [ath9k-devel] [Moblin Dev] Wireless is keep on disconnecting
From: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
To: Bob Copeland <me@bobcopeland.com>, davem@davemloft.net
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	arjan@linux.intel.com, "Li, Yan" <yan.i.li@intel.com>,
	dev@moblin.org, alainswb <alainswb@free.fr>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello bob,

On Thu, Jan 14, 2010 at 9:45 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Jan 13, 2010 at 2:07 AM, Jaswinder Singh Rajput
> <jaswindermobile@gmail.com> wrote:
>> Here is my test with iperf, even though iperf client does not work so
>> I used iperf server and get speed of approx 19 Mbits/sec. Now my issue
>> is why speed is soo slow ?
>
> Is your AP n-capable?  You won't get much above 20 Mbps TCP throughput
> in 802.11a/g at 54 Mbits rates due to various overheads.
>

I run these tests on Wireless A/G.

Can you please let me know what are the overheads for this performance
degradation.

As I shown in my last message, I am getting 15 Mbps.

Thanks,
--
JSR
