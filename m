Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33003 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2CFVlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 16:41:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203062210340.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org>
 <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
 <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
 <alpine.LFD.2.02.1203060927190.2742@ionos> <alpine.LFD.2.02.1203060957140.2742@ionos>
 <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de>
 <alpine.LFD.2.02.1203062101040.2742@ionos> <87r4x5zbe5.fsf@turtle.gmx.de> <alpine.LFD.2.02.1203062210340.2742@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 13:40:57 -0800
Message-ID: <CA+55aFyyRQtj2A2Dzb26QbNpTeG7a3Y+2ExRdgp3=o-MAYFyhQ@mail.gmail.com> (sfid-20120306_224123_723471_2F45C735)
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sven Joachim <svenjoac@gmx.de>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 6, 2012 at 1:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Can you pick it up directly or want me to send it via tip ?

I can certainly pick it up directly, but I want the sane version, not
the "random monkeys typing" version. Please.

                   Linus
