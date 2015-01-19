Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:46331 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbASMVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 07:21:12 -0500
Received: by mail-qc0-f181.google.com with SMTP id l6so16985556qcy.12
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 04:21:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com>
References: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Mon, 19 Jan 2015 16:20:56 +0400
Message-ID: <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com> (sfid-20150119_132116_371481_3D724D52)
Subject: Re: b43 bcm43228 and linux 3.18.3
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anybody can helps me debug this?

2015-01-17 20:59 GMT+03:00 Vasiliy Tolstov <v.tolstov@selfip.ru>:
> Hi all. I have 3.18.3 kernel and bcm43228, firstly all works fine, but
> after connection with my zyxel router i can't ping it ip (after 1-2
> min). Connection worked fin, but nothing transmitted =(.
> I'm try to disable qos, but this not helps, i'm try to enable
> verbose=3, but in dmesg nothing interesting. Time after time b43
> driver moved from 5Ghz to 2.4Ghz to 5Ghz and so.
> How can i debug this issue? I'm realy love free opensource drivers.
> Thanks
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov@selfip.ru
> jabber: vase@selfip.ru



-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
