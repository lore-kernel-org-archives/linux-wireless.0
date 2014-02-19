Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35591 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBSAdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:33:50 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so13105322lbi.27
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:33:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 16:33:29 -0800
Message-ID: <CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com> (sfid-20140219_013354_116751_2EF4F3D7)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 9:43 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Handle AUTO bandwidth setting in db2rd.
> Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
> in case of AUTO bw calculation.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Please elaborate more on this. Who deals with the automatic math on
the bandwidth?

  Luis
