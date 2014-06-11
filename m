Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34542 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaFKFDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 01:03:31 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so21688qcv.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 22:03:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com>
Date: Wed, 11 Jun 2014 07:03:30 +0200
Message-ID: <CALhHN=rzHzSr67W9KoC8u5cARrckOgQA-m26fmhXwX85aEcKoA@mail.gmail.com> (sfid-20140611_070333_826447_C5FF0055)
Subject: Re: [RFC 1/2] crda: simplify text parsing for country/rules
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2014 00:09, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> Remove strange parsers.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Did you test this with the different types of accepted rules?
>

Tested with current db.txt (+AUTO-BW in some cases).

BR
Janusz
