Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42486 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3J1Uhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 16:37:51 -0400
Received: by mail-lb0-f171.google.com with SMTP id x18so3302292lbi.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 13:37:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
	<CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
	<CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
Date: Mon, 28 Oct 2013 14:37:49 -0600
Message-ID: <CAMP44s14GXj4Nvy2qCMwyFGBc8VoSK3xFMkd2jEjQBTO1PQZxA@mail.gmail.com> (sfid-20131028_213754_223887_2EE4BDBD)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 1:27 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:

> Another side porint? Also all the beacons from that AP are malformed
> but probe responses are fine, weird??

Also, here's a message I get some times. I don't think it's related to
the issue at hands, but who knows:

Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: fail to flush all
tx fifo queues Q 11
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Current SW read_ptr
137 write_ptr 154
Oct 28 14:28:47 nysa kernel: iwl data: 00000000: 00 fe ff 01 00 00 00
00 00 00 00 00 00 00 00 00  ................
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(0) = 0x00000000
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(1) = 0xc010b098
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(2) = 0x00000000
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(3) = 0x803000e3
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(4) = 0x00000000
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(5) = 0x00000000
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(6) = 0x00000000
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: FH TRBs(7) = 0x00709041
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 0 is active and
mapped to fifo 3 ra_tid 0x0000 [228,228]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 1 is active and
mapped to fifo 2 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 2 is active and
mapped to fifo 1 ra_tid 0x0000 [105,105]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 3 is active and
mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 4 is active and
mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 5 is active and
mapped to fifo 4 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 6 is active and
mapped to fifo 2 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 7 is active and
mapped to fifo 5 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 8 is active and
mapped to fifo 4 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 9 is active and
mapped to fifo 7 ra_tid 0x0000 [66,66]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 10 is active and
mapped to fifo 5 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 11 is active and
mapped to fifo 1 ra_tid 0x0000 [137,154]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 12 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 13 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 14 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 15 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 16 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 17 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 18 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]
Oct 28 14:28:47 nysa kernel: iwlwifi 0000:02:00.0: Q 19 is inactive
and mapped to fifo 0 ra_tid 0x0000 [0,0]

-- 
Felipe Contreras
