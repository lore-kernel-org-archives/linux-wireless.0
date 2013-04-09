Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46332 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3DIXAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 19:00:40 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so7369898wgh.8
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 16:00:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmon4K_sFR3JP47YGP13HtepEg=mt3=Y8nQX8fV+cdFZ5rg@mail.gmail.com>
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
	<1365398445.32740.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmomGT4grPwA0dSGqPD=Zi=dZk6WwpqKEXXDvfLUqr08o0w@mail.gmail.com>
	<1365413949.24195.YahooMailNeo@web193502.mail.sg3.yahoo.com>
	<1365433751.96373.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-Vmon4K_sFR3JP47YGP13HtepEg=mt3=Y8nQX8fV+cdFZ5rg@mail.gmail.com>
Date: Tue, 9 Apr 2013 16:00:38 -0700
Message-ID: <CAJ-Vmo===nANf3g5psxf3aV7L8jVQ8mjRP+1WM0PSS9PgcGHBA@mail.gmail.com> (sfid-20130410_010043_694058_94C6751E)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Yes, "WLAN_ACTIVE" here is just both TX and RX activity.

So if it were working, that would stay low.



adrian
