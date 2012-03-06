Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:56757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab2CFI2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 03:28:34 -0500
Date: Tue, 6 Mar 2012 09:28:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Sven Joachim <svenjoac@gmx.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203060927190.2742@ionos> (sfid-20120306_092838_180979_CB27BBCC)
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de> <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Mar 2012, Linus Torvalds wrote:

> Thomas, should we just plan on reverting that commit from mainline? It
> clearly causes regressions.

Give me a day or two to figure out why it breaks stuff. I have no idea
why it should wreckage anything.

Thanks,

	tglx
