Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35472 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161989Ab3DEQlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 12:41:39 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so785706wib.15
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 09:41:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
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
Date: Fri, 5 Apr 2013 09:41:37 -0700
Message-ID: <CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com> (sfid-20130405_184146_837853_6D15D798)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 April 2013 08:24, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Sujith,
>     Thanks for the elaborate answer which helps a lot.
> But the question is for 2-wire coexistence, are there any weight register?
> Because I did not see the same in ath9k code base neither in btcoex.c,
> gpio.c etc. The weight registers are only available for 3-wire. Please let
> me know if there is any weight register in AR9287 for 2-wire and its address
> in AR9287?

Yup. The weight register is there for 2-wire. It just has a different meaning.

I'm digging thorough this, i'll let you know when I know more.

> Do you know if AR9287 also supports MCI mode?

Nope. It doesn't.


Adrian
