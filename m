Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48583 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3KTKaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 05:30:11 -0500
Received: by mail-lb0-f175.google.com with SMTP id x18so1605672lbi.6
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 02:30:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131104191850.GA1989@tuxdriver.com>
References: <20131011202459.GF14329@tuxdriver.com> <5272E897.8060606@archlinux.org>
 <20131104191850.GA1989@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 20 Nov 2013 11:29:50 +0100
Message-ID: <CAB=NE6XU80NwLA=qW8jOBPZEmiSJ6NoHXDgp1bfs5=5GYnUi3A@mail.gmail.com> (sfid-20131120_113016_586135_D7DC55B3)
Subject: Re: [ANN] wireless-regdb: master-2013-10-11
To: "John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 4, 2013 at 8:18 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Nov 01, 2013 at 12:32:39AM +0100, Thomas Bächler wrote:
>> Am 11.10.2013 22:24, schrieb John W. Linville:
>> > (Cutting the short log, since the original version got classified as
>> > SPAM on vger.kernel.org...??)
>> >
>> > A new release of wireless-regdb (master-2013-10-11) is available at:
>> >
>> > http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.10.11.tar.gz
>> >
>> > Here is the short log of the changes included since the 2013-02-13
>> > release:
>> >
>> > SNIP -- you'll have to check it yourself:
>>
>> We can't use the database file:
>>
>> $ regdbdump regulatory.bin
>> Database signature verification failed.
>
> OK, I probably screwed-up something.  I'll investigate, but it may
> take few days while I recover from some extended travel...

Hey John, it seems other folks are reporting this as well [0].

[0] http://forums.gentoo.org/viewtopic-p-7440278.html

  Luis
