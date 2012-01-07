Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43596 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2AGF3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 00:29:12 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-ID: <20231.55475.813214.492951@gargle.gargle.HOWL> (sfid-20120107_062932_608498_B0A06952)
Date: Sat, 7 Jan 2012 11:01:31 +0530
To: =?utf-8?Q?=E6=9D=8E=E5=88=9A?= <gang.li@watchdata.com>
CC: <linux-wireless@vger.kernel.org>,
	'Ath9k Devel List' <ath9k-devel@lists.ath9k.org>
Subject: Question about duration of data frame in ath9k_htc
In-Reply-To: <20120107020151.B53C81FFF8@mail.watchdata.com.cn>
References: <CADGLRPmkbTp-azGJ2=CJum=Y8Mrf7fTbaE9Oi8Om+DQyu7d9uA@mail.gmail.com>
	<20120107020151.B53C81FFF8@mail.watchdata.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

李刚 wrote:
> 	From wireshark, I noticed that when send an data frame , the
> duration of frame control is fixed at 60 , no matter the frame length is 100
> bytes or 1000 bytes.
> 
> 	It seems this value is calculated in firmware and should be correct.
> But I don't know why. And this value can be set in mac80211?

Duration calculation is broken for ath9k_htc.
See: http://linuxwireless.org/en/users/Drivers/ath9k_htc#TODO

Sujith
