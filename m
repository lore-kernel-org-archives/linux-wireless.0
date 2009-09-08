Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f192.google.com ([209.85.223.192]:39320 "EHLO
	mail-iw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZIHGmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 02:42:11 -0400
Received: by iwn30 with SMTP id 30so1001240iwn.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 23:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <70EB52E9BF7F43BBBBC899826FD0D3C4@inin.local>
References: <b55cabb00909070639s4a6f3c1cl8c3e2eccceaf81e8@mail.gmail.com>
	<43e72e890909071436ub99bddbx3dd531d09f322b4a@mail.gmail.com>
	<70EB52E9BF7F43BBBBC899826FD0D3C4@inin.local>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Mon, 7 Sep 2009 23:41:54 -0700
Message-ID: <43e72e890909072341h20eb089avd71da0385c2c37c2@mail.gmail.com>
Subject: Re: compat-wireless-old for ARM
To: Marcel <marcelcastrobr@gmail.com>
Cc: AMAR SAHUKAR <amarsahu7@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2009 at 11:10 PM, Marcel<marcelcastrobr@gmail.com> wrote:
> Hello Luis,
>        Do you think it should be viable to bring it down to kernel 2.6.22
> using armeb?

What's armeb?

It should be possible for sure to bring it down to even 2.6.21, maybe
even more. There is already code for 2.6.21..2.6.24, the gaps are all
that just need to be accounted for as well as testing.

>        If so, I can help to test since I am very interested in ath5k.

Great!

   Luis
