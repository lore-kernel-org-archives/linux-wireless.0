Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43840 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3DJFhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 01:37:08 -0400
Received: by mail-wg0-f54.google.com with SMTP id a12so70374wgh.33
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 22:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365561451.4973.YahooMailNeo@web193504.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
	<CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com>
	<1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<1365413949.24195.YahooMailNeo@web193502.mail.sg3.yahoo.com>
	<1365433751.96373.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-Vmon4K_sFR3JP47YGP13HtepEg=mt3=Y8nQX8fV+cdFZ5rg@mail.gmail.com>
	<CAJ-Vmo===nANf3g5psxf3aV7L8jVQ8mjRP+1WM0PSS9PgcGHBA@mail.gmail.com>
	<1365561451.4973.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Tue, 9 Apr 2013 22:37:05 -0700
Message-ID: <CAJ-VmokkC4veD4UMfP99Rbkyd3OZMxK46vZaQfqbDX9Ux6E3vA@mail.gmail.com> (sfid-20130410_073715_547805_A15F3E5D)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right, but same deal - if it asserts the line, it should stomp wifi
transmission in your particular scheme.



adrian


On 9 April 2013 19:37, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     Thanks for your response. During googling, I had come across the
> following 2-wire coexistence solution from owl modules.
>
> http://support.connectblue.com/display/PRODWLAN/cB-OWL22x+Bluetooth+co-existence+application+note
> According to this application note, for 2-wire coexistence, WLAN_ACTIVE and
> BT_PRIORITY signals are used rather than WLAN_ACTIVE and BT_ACTIVE.  What is
> your opinion on this? And as I understand owl modules are based on Atheros
> chipsets.
>
> Regards
> Sandeep.
>
> From: Adrian Chadd <adrian@freebsd.org>
> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
> Cc: Sujith Manoharan <sujith@msujith.org>; ath9k-devel
> <ath9k-devel@lists.ath9k.org>; "linux-wireless@vger.kernel.org"
> <linux-wireless@vger.kernel.org>
> Sent: Wednesday, 10 April 2013 4:30 AM
>
> Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
>
> Hi,
>
> Yes, "WLAN_ACTIVE" here is just both TX and RX activity.
>
> So if it were working, that would stay low.
>
>
>
> adrian
>
>
