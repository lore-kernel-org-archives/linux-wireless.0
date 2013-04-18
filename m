Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43413 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab3DROQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 10:16:51 -0400
Received: by mail-we0-f174.google.com with SMTP id u12so2376751wey.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 07:16:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366281249.7026.YahooMailNeo@web193504.mail.sg3.yahoo.com>
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
	<1366084534.24187.YahooMailNeo@web193501.mail.sg3.yahoo.com>
	<CAJ-Vmoki6FUETFLkThp1AvZ3R_2kCd5Ro83OuvsfW0nZ5pfJ2w@mail.gmail.com>
	<1366194814.88121.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-Vmokx0MbTC47+0fcRt9yQshfTaPEDte2A=7Ycn2bzwLSPxg@mail.gmail.com>
	<1366248389.18545.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmomXz93U7HCmscd=NVZKQ+RFbty+Xh_wcOPYEDhX57ptbw@mail.gmail.com>
	<1366281249.7026.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Thu, 18 Apr 2013 07:16:48 -0700
Message-ID: <CAJ-VmokO+Tc+5k+=d2qiZSFQtrLFaHuYgpPK7r_OO5PKBue_TQ@mail.gmail.com> (sfid-20130418_161659_781773_E7EAEF28)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 April 2013 03:34, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     Yes I also fixed the weights as being reflected in the regdump register.
> Let me also try with other options for MODE register.

Ok.

> Please clarify my understanding below on rx_clear for WLAN: rx_clear is TRUE
> when any one of the following conditions are TRUE:
> a) WLAN is transmitting.
> b) WLAN is receiving.
> c) air medium is clear as per CCA assessment based on signal strength.
>
> What is the meaning of " but not a wifi signal" in your reply below?

c). If there's some strong signal in the air that exceeds the CCA
threshold but isn't a decodable wifi signal, rx_clear is cleared.




Adrian
