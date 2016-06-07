Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35212 "EHLO
	mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcFGABJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 20:01:09 -0400
Received: by mail-it0-f44.google.com with SMTP id z189so59428184itg.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 17:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
 <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
 <8737orucq4.fsf@toke.dk> <CAJ-VmokvcPUxfROkTtCCO_RCR0BSeDxNSczj4Y_ti5KyDbThMQ@mail.gmail.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 6 Jun 2016 17:01:08 -0700
Message-ID: <CAJ-Vmoka=_Wv==f61ZWJe8P_KoL6jyHhpyPDah3QCn3AZbcmsA@mail.gmail.com> (sfid-20160607_020114_318883_2CB7E913)
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[snip]

I also found one of my notes in my version of this - how can we
estimate the duration of an A-MPDU, when we only get hardware
de-encapsulated frames?



-adrian
