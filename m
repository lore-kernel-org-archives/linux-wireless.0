Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:55164 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0ALROc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 12:14:32 -0500
Received: by iwn35 with SMTP id 35so15722581iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 09:14:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	 <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	 <4B4C8320.8060801@free.fr>
	 <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	 <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
Date: Tue, 12 Jan 2010 22:44:31 +0530
Message-ID: <995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
Subject: Re: [Moblin Dev] Wireless is keep on disconnecting
From: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: alainswb <alainswb@free.fr>, dev@moblin.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

On Tue, Jan 12, 2010 at 10:16 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Jan 12, 2010 at 7:24 AM, Jaswinder Singh Rajput
> <jaswindermobile@gmail.com> wrote:
>
>>> I keep on getting "Network Lost" message on moblin 2.1 when I transfer
>>> some big file. I am trying to understand Is it a feature or a Bug.
>>>
>>> My other machines are working great with Wireless even Windows XP
>>> running on Netbook never did this to me.
>
> Your report lacks a lot of information, its unclear what Moblin 2.1 is
> using for its kernel for those who are not following moblin
> development on a regular basis, and if its anything older than 2.6.32
> its old and I recommend upgrading. May want to try to upgrade your
> kernel or upgrade to a stable release of compat-wireless snapshot for
> example:
>
> http://wireless.kernel.org/en/users/Download/stable
>

I am attaching dmesg on Acer Aspire One D250 Netbook.

I am going to build latest git kernel and with latest wireless kernel
on it and let you know the status.

Please let me know if you need more information.

Thank you,
--
JSR
