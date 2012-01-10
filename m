Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49299 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2AJH3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 02:29:34 -0500
Received: by werm1 with SMTP id m1so3231937wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 23:29:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6ryJT1Nw8Yxrj8CftERjO=y7kYc-9cTP5Bj-N-=NniAhdg@mail.gmail.com>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
	<CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com>
	<20120109222544.11008.qmail@stuge.se>
	<CACna6ryJT1Nw8Yxrj8CftERjO=y7kYc-9cTP5Bj-N-=NniAhdg@mail.gmail.com>
Date: Tue, 10 Jan 2012 08:29:33 +0100
Message-ID: <CACna6ryuR1hoJGH1Gy_v_N-HUhgL_8rxZf_-9q=DPQW-ERGX0w@mail.gmail.com> (sfid-20120110_082938_306846_09694377)
Subject: Re: BCM43231
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 stycznia 2012 08:00 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> I've quickly tried usbmon userspace tool, but not much more luck with
> it. Example from this tool:
>
> f2c19e40 6.317817 S Ci:2:013:0 s 80 06 0200 0000 0027 39 <
> f2c19e40 6.318305 C Ci:2:013:0 0 39 =
>    09022700 010100a0 64090400 0003ff02 ff000705 81031000 04070582 02000200
>     . . ' .  . . . .  d . . .  . . . .  . . . .  . . . .  . . . .  . . . .
>
> Maybe it requires some switch or sth... unfortunately it's not
> documented at all ;/

usbmon -s 1024 > dump.txt
:)

-- 
Rafał
