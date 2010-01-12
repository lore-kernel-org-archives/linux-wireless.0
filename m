Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37052 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0ALQrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 11:47:14 -0500
Received: by pzk1 with SMTP id 1so6346398pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 08:47:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	<995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	<4B4C8320.8060801@free.fr> <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 12 Jan 2010 08:46:53 -0800
Message-ID: <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
Subject: Re: [Moblin Dev] Wireless is keep on disconnecting
To: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
Cc: alainswb <alainswb@free.fr>, dev@moblin.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 7:24 AM, Jaswinder Singh Rajput
<jaswindermobile@gmail.com> wrote:

>> I keep on getting "Network Lost" message on moblin 2.1 when I transfer
>> some big file. I am trying to understand Is it a feature or a Bug.
>>
>> My other machines are working great with Wireless even Windows XP
>> running on Netbook never did this to me.

Your report lacks a lot of information, its unclear what Moblin 2.1 is
using for its kernel for those who are not following moblin
development on a regular basis, and if its anything older than 2.6.32
its old and I recommend upgrading. May want to try to upgrade your
kernel or upgrade to a stable release of compat-wireless snapshot for
example:

http://wireless.kernel.org/en/users/Download/stable

  Luis
