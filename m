Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54374 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPNcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 08:32:02 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so12239773wiv.11
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 05:32:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=oTxxeDxym9fDOrH5XLm4pNngBV7tFfxpJ5bYORZnCu=g@mail.gmail.com>
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAEFj986SVguSMp=oQ3aNKAv+nZkcYiVSiPupLj8Y6=57YVrSmQ@mail.gmail.com>
	<CALhHN=oTxxeDxym9fDOrH5XLm4pNngBV7tFfxpJ5bYORZnCu=g@mail.gmail.com>
Date: Tue, 16 Dec 2014 21:32:00 +0800
Message-ID: <CAEFj986nX6+GyS0x64veOuEEJsGf-aJFq4aT_ZDxqmPJ=Y3kBg@mail.gmail.com> (sfid-20141216_143206_575958_C25C0C9A)
Subject: Re: [PATCH 1/2] ath10k: fix low TX rates when IBSS and HT
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2014 at 7:22 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 16 December 2014 at 12:10, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Hi, Janusz
>>
>> I have applied the three patches and tested with firmware
>> 999.999.0.636 but not working.
>>
>> Any advice what's wrong?
>>
> mac peer 04:f0:21:0c:a5:43 qos 0 - this is suspect.

Not so sure.

> What is your test procedure (I see some mesh ...)?

I named the interface as mesh0 but it is ibss or adhoc mode. I use the
iw util to setup the adhoc interface.

---
ChunYeow
