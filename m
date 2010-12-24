Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46765 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0LXQCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 11:02:06 -0500
Received: by fxm20 with SMTP id 20so7971751fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 08:02:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=GgTWU1QmoqxM_rA8jUX7814PvZqsEGvcnc6ps@mail.gmail.com>
References: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com>
	<28292.82403.qm@web56807.mail.re3.yahoo.com>
	<AANLkTi=GgTWU1QmoqxM_rA8jUX7814PvZqsEGvcnc6ps@mail.gmail.com>
Date: Fri, 24 Dec 2010 11:02:04 -0500
Message-ID: <AANLkTi=OcXfoo8gFQ+qTYDgL4XaKXiGZpUSSiL8yT_ho@mail.gmail.com>
Subject: Re: carl9170 and debian squeeze
From: Der Engel <engelster@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you, I'll try  and search for a version that compiles.

The reason I went with bleeding-edge and not the stable version is
because the stable versions are hosted at orbit-lab.org and all the
download links are broken so I couldn't find another place from where
to download it.

Der

On Fri, Dec 24, 2010 at 7:00 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Dec 24, 2010 at 12:29 PM, Walter Goldens
> <goldenstranger@yahoo.com> wrote:
>> This is because of driver-select. To make a long story short, download and install the entire compat-wireless suit (without driver select). If the current version fails to compile download the one from the day before and so on until you find a version which compiles entirely. Then you'll have support for all of your wireless cards.
>>
>>
>> Walter
>>
>
> I always wonder why people start with bleeding-edge version of compat-wireless.
> A daily bleeding-edge version might be broken, try a previous version
> (as Walter recommended).
> Check also the automated reports of Luis which are sent to this ML.
> There are "half-baked" version around...
>
> "Der" did you try a stable .36 or stable .37-rcX of c-w?
>
> So you asked for carl9170 and not in combination with iwlwifi!
> For a new topic open a new thread, please.
> As Walter pointed out, do a full compilation of c-w.
>
>
> - Sedat -
>
