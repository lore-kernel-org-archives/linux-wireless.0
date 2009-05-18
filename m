Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:51873 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZERRw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 13:52:57 -0400
Received: by pzk13 with SMTP id 13so2088866pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 10:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090518123858.GA2814@tuxdriver.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	<1242327298.4227.25.camel@localhost.localdomain> <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	<1242334636.4227.134.camel@localhost.localdomain> <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
	<43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
	<1242478657.10005.72.camel@johannes.local> <20090518123858.GA2814@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 10:52:39 -0700
Message-ID: <43e72e890905181052p2d227004ie2bfc401f256d729@mail.gmail.com>
Subject: Re: Scan while TX/RX'ing a lot of data
To: "John W. Linville" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com,
	David Miller <davem@davemloft.net>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 5:38 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, May 16, 2009 at 02:57:37PM +0200, Johannes Berg wrote:
>
>> Anyway, bottom line is that I don't think we should change the APIs in
>> any way, we should instead make the scan smarter by spreading it out if
>> we're active. This even applies to scanning while in an IBSS -- stop
>> beaconing, then go scan etc.
>
> ACK

OK FYI -- I think Senthil is up for taking this on.

  Luis
