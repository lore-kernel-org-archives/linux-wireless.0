Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:56052 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZFUAsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 20:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906191555390.16802@localhost.localdomain>
References: <20090615214735.GE23972@bombadil.infradead.org>
	<20090616021011.GF23972@bombadil.infradead.org> <20090616032034.GA17932@kroah.com>
	<20090616042113.GA5680@tesla> <20090616093401.GA11602@jm.kir.nu>
	<20090616181705.GB31506@tesla> <20090619150015.GC1389@ucw.cz>
	<43e72e890906191010v4b2e79a5x2c7b722b8209933c@mail.gmail.com>
	<20090619221909.GC2229@elf.ucw.cz> <alpine.LFD.2.01.0906191555390.16802@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 20 Jun 2009 17:47:43 -0700
Message-ID: <43e72e890906201747qb409fa7ue1bc84272417e03@mail.gmail.com>
Subject: Re: [RFC] Documentation: add documentation for rc-series and merge
	window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Jouni Malinen <j@w1.fi>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Greg KH <greg@kroah.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 3:56 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 20 Jun 2009, Pavel Machek wrote:
>>
>> Non-intrusive bugfixes _are_ welcome after -rc1.
>
> After -rc1, yes.
>
> After something like -rc5? No.
>
> They had better be _really_ important things, and _really_ obvious and
> non-intrusive.  Not just "any bug".

For the sake of documentation and to help developers better understand
this it would be nice if we could be a little more clear here. I can
think of patches which may not be obvious but yet very important, for
example. Can we simply document that the patches must be important,
non-intrusive, and must have a very clear commit log entry of what it
is fixing. Judgment for the degree of importance of the patch can be
left up to the subsystem maintainer.

Is it reasonable to document this as I describe above?

  Luis
