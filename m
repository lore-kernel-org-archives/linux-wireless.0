Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2ENICo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:02:44 -0400
Message-ID: <1336982561.4303.10.camel@jlt3.sipsolutions.net> (sfid-20120514_100249_526247_CA85F9D2)
Subject: Re: ath9k: write-only variable rx.rxotherant ?!?!?
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 May 2012 10:02:41 +0200
In-Reply-To: <CAOpc7mEZGZMCCBnnLo-v6ooz4qgKXOeF7kJeb3yzeeV8L-g5bA@mail.gmail.com> (sfid-20120514_095731_639680_F973C52A)
References: <CAOpc7mEZGZMCCBnnLo-v6ooz4qgKXOeF7kJeb3yzeeV8L-g5bA@mail.gmail.com>
	 (sfid-20120514_095731_639680_F973C52A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 09:57 +0200, Holger Schurig wrote:
> I looks like sc->rx.rxotherant is an almost write-only variable: "grep
> -r rxotherant *":
> 
> ./ath9k/recv.c:	sc->rx.rxotherant = 0;
> ./ath9k/recv.c:				if (++sc->rx.rxotherant >= 3)

that reads it too

johannes

