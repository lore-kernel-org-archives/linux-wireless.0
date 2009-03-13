Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:57878 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZCMESD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 00:18:03 -0400
Received: by wf-out-1314.google.com with SMTP id 28so191399wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 21:18:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18873.53124.115355.862512@gargle.gargle.HOWL>
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
	 <18873.53124.115355.862512@gargle.gargle.HOWL>
Date: Thu, 12 Mar 2009 21:18:01 -0700
Message-ID: <43e72e890903122118p5533bb4eke512f947c8879edf@mail.gmail.com> (sfid-20090313_051815_017454_89A4E5F1)
Subject: Re: Which APs to disregards from in inputting into the bss list
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 8:14 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> Do we want to ignore certain APs if we determine they are bogus? An
>> example is 11n APs with WEP/TKIP.
>
> They are not bogus, we just fall back to legacy association.

What if its HT only.

  Luis
