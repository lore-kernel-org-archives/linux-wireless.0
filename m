Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38861 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3DORpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 13:45:15 -0400
Received: by mail-we0-f173.google.com with SMTP id t57so3837530wey.18
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 10:45:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366042437.8316.YahooMailNeo@web193506.mail.sg3.yahoo.com>
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
	<1365561451.4973.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmokkC4veD4UMfP99Rbkyd3OZMxK46vZaQfqbDX9Ux6E3vA@mail.gmail.com>
	<1365574412.20937.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmonwA=25ooSXFrNJydkERWwP7D_iY+VvDu_wz+=G7tNoBQ@mail.gmail.com>
	<1366012397.74181.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-Vmomdv1Z2_H7L_=wU+g355b0HOgMQBt6MXkJv+Aqr1EG=Rg@mail.gmail.com>
	<1366042437.8316.YahooMailNeo@web193506.mail.sg3.yahoo.com>
Date: Mon, 15 Apr 2013 10:45:14 -0700
Message-ID: <CAJ-Vmon1gx_MNaDSNtbS073bR8VxCsnia2PALOXYBgo_O+P3ag@mail.gmail.com> (sfid-20130415_194520_942457_9B1F84E1)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... this is way way too complicated.

There's a debugfs thing (regidx/regval) that lets you read/write
individual register values.

So please dump the contents of these registers:


ar5416phy.h:#define     AR_BT_COEX_MODE            0x8170
ar5416phy.h:#define     AR_BT_COEX_WEIGHT          0x8174
ar5416phy.h:#define     AR_BT_COEX_MODE2           0x817c
ar5416reg.h:#define     AR_BT_COEX_WEIGHT2      0x81c4



adrian
