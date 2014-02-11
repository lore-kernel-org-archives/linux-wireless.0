Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from turkos.aspodata.se ([192.5.36.36]:41942 "EHLO
	turkos.aspodata.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaBKHxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 02:53:24 -0500
From: karl@aspodata.se
To: sandeep.suresh@yahoo.co.in
cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] How to prepare a 802.11 channel map with energy using ATH9K
In-reply-to: <1392088149.51199.YahooMailNeo@web193501.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com> <515A0847.7000306@gmail.com> <1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com> <CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com> <1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com> <CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com> <1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com> <CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com> <1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com> <20830.46610.23754.783231@gargle.gargle.HOWL> <1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com> <CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com> <CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com> <CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com> <1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com> <1366084534.24187.YahooMailNeo@web193501.mail.sg3.yaho
  o.com> <CAJ-Vmoki6FUETFLkThp1AvZ3R_2kCd5Ro83OuvsfW0nZ5pfJ2w@mail.gmail.com> <1366194814.88121.YahooMailNeo@web193506.mail.sg3.yahoo.com> <CAJ-Vmokx0MbTC47+0fcRt9yQshfTaPEDte2A=7Ycn2bzwLSPxg@mail.gmail.com> <1366248389.18545.YahooMailNeo@web193503.mail.sg3.yahoo.com> <CAJ-VmomXz93U7HCmscd=NVZKQ+RFbty+Xh_wcOPYEDhX57ptbw@mail.gmail.com> <1366281249.7026.YahooMailNeo@web193504.mail.sg3.yahoo.com> <CAJ-VmokO+Tc+5k+=d2qiZSFQtrLFaHuYgpPK7r_OO5PKBue_TQ@mail.gmail.com> <1369118418.41680.YahooMailNeo@web193504.mail.sg3.yahoo.com> <CAJ-Vmo=533O+3tDhjbzyOd1PRMX0kJB8guCc_9xyiHioifteJg@mail.gmail.com> <1369201780.73721.YahooMailNeo@web193506.mail.sg3.yahoo.com> <1372140589.84426.YahooMailNeo@web193506.mail.sg3.yahoo.com> <CADxDmp78kQSknV6ib+0RXCqCy9jsNxO-m9cA7kxW+x3SEMKgZQ@mail.gmail.com> <1373035549.60009.YahooMailNeo@web193504.mail.sg3.yahoo.com> <1391784518.29684.YahooMailNeo@web193505.mail.sg3.yahoo.com> <20140209214108.506F38045B78@turkos.aspodata.se> <1392088149.51199.YahooMailNeo@
 web193501.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Message-Id: <20140211075323.265FD8045B88@turkos.aspodata.se> (sfid-20140211_085328_302225_AABBCDF7)
Date: Tue, 11 Feb 2014 08:53:21 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sandeep:
> Thanks Karl for the detailed response...will go through it.

> Just one query....will the spectral scan work in parallel with WiFi
> AP or WiFi CLient mode?

Don't know, just found out how to do a simple scan, don't really
use wireless myself. The scanning exercise is to investigate problems
that a customer have.

> What I mean is that when the WiFi chipset (AR92xx/AR93xx) is
> operating in AP or client mode, based on request from Linux
> userspace, it should also perform a scan of the spectrum and
> return the energy values.

Wouldn't that be problematic. When you put out energy to the antenna,
do the receiver sense that, and if so wouldn't the output energy
more or less mask the input signal ?

///

Perhaps this don't need to be cross-posted.

Regards,
/Karl Hammar

-----------------------------------------------------------------------
Aspo Data
Lilla Aspo 148
S-742 94 Osthammar
Sweden
+46 173 140 57


