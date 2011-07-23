Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51893 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GWIt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:49:57 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so4932847pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110723103725.6d5bab09@maggie>
References: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
	<1311412213-3825-2-git-send-email-zajec5@gmail.com>
	<20110723103725.6d5bab09@maggie>
Date: Sat, 23 Jul 2011 10:49:55 +0200
Message-ID: <CACna6rxZqmC-n1iQGX+KnoPDFRx4gY1gV+td0gPi2wu_WnT1XQ@mail.gmail.com> (sfid-20110723_105049_288191_AC6048EB)
Subject: Re: [PATCH 1/2] ssb: define boardflags
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 lipca 2011 10:37 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sat, 23 Jul 2011 11:10:11 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> They are SPROM specific, so all should be defined in ssb code.
>
> Oh, well. I'm not sure.
> Most of these currently are defined in b43 code, because they are b43-specific
> and _not_ ssb specific. If we decide to define them in ssb, they need to be
> removed from b43, at least.

Well, SPROM is board specific (not 80211 core specific), so I believe
the same applies to boardflags, doesn't it? Boardflags are read from
SPROM, so it makes sense for me.

I planned to remove them from b43 and b43legacy and driver_pci. Just
wanted to provide minimal version for now, as John may want to take it
still for 3.1.

-- 
Rafał
