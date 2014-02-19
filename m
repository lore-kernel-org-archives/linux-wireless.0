Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:50008 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaBSWA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 17:00:27 -0500
Received: by mail-la0-f49.google.com with SMTP id y1so741471lam.8
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 14:00:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com>
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com> <CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 14:00:05 -0800
Message-ID: <CAB=NE6UR3yQOSZr7NXA4kO2hKre0zBsmK9H1MTYZ=9Wh_=9AtA@mail.gmail.com> (sfid-20140219_230038_487558_335A1C21)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:12 PM, Janusz Dziedzic
<janusz.dziedzic@gmail.com> wrote:
> 2014-02-19 1:33 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
>> On Wed, Feb 12, 2014 at 9:43 AM, Janusz Dziedzic
>> <janusz.dziedzic@tieto.com> wrote:
>>> Handle AUTO bandwidth setting in db2rd.
>>> Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
>>> in case of AUTO bw calculation.
>>>
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> Please elaborate more on this. Who deals with the automatic math on
>> the bandwidth?
>>
> cfg80211,
>
> Please check patch:
> cfg80211: regulatory introduce maximum bandwidth calculation

OK, so we don't send the max bandwidth attribute now, what about
support for older kernels?

  Luis
