Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55000 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3DEJNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 05:13:23 -0400
Received: by mail-wi0-f181.google.com with SMTP id hj8so358750wib.14
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 02:13:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
Date: Fri, 5 Apr 2013 02:13:22 -0700
Message-ID: <CAJ-Vmo=sJRgfqztsbcq39Tf7imBG+2CKZ5u3qO4RXzSO8VtmJg@mail.gmail.com> (sfid-20130405_111333_455407_C90114C1)
Subject: Re: AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 April 2013 02:06, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Thanks Mr.Adrian for the information. I had a look at the source code for
> Ath9k. For 2-wire coexistence, other than GPIO configuration (direction, Mux
> etc) for WLAN_ACTIVE and BT_ACTIVITY, is there also weight register
> configuration for BT and WLAN for 2-wire?
> What exactly is the meaning of these weight registers?

I've no idea just yet, sorry. I'm still trying to digest how bluetooth
coexistence works.



Adrian
