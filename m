Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35813 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaBSGMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 01:12:03 -0500
Received: by mail-ie0-f176.google.com with SMTP id rd18so2508372iec.21
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 22:12:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com>
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com>
Date: Wed, 19 Feb 2014 07:12:01 +0100
Message-ID: <CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com> (sfid-20140219_071211_453714_5945AD88)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-02-19 1:33 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> On Wed, Feb 12, 2014 at 9:43 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> Handle AUTO bandwidth setting in db2rd.
>> Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
>> in case of AUTO bw calculation.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Please elaborate more on this. Who deals with the automatic math on
> the bandwidth?
>
cfg80211,

Please check patch:
cfg80211: regulatory introduce maximum bandwidth calculation

BR
Janusz
