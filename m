Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33980 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZHaTfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:35:30 -0400
Received: by bwz19 with SMTP id 19so3007076bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 12:35:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908312127.57610.mb@bu3sch.de>
References: <4A9BFCCB.6040808@ufra.edu.br> <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <200908312127.57610.mb@bu3sch.de>
Date: Mon, 31 Aug 2009 20:35:31 +0100
Message-ID: <3ace41890908311235i62ab0510neb8b2021c3f2945e@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 8:27 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Monday 31 August 2009 20:26:22 Hin-Tak Leung wrote:
>> It would appear that the rw driver's ieee80211->mac80211 conversion
>> has broken big- endian platforms, at a first guess.
>
> Last time I tested the device worked fine on my powerbook with zd1211rw/mac80211.
> But that's maybe two or three release cycles in the past.
>
> --
> Greetings, Michael.
>

The rw ieee80211->mac80211 conversion happens in 2.6.27->26.28 ...
Iguess the question is whether it was 2.6.28 or 2.6.27 you had success
with? That's unfortunately two *and* three cycles in the past,
respectively :-).
