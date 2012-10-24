Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57052 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2JXVWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 17:22:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1496678pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 14:22:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121024194547.GA19060@shredder>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
	<CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
	<20121024194547.GA19060@shredder>
Date: Wed, 24 Oct 2012 14:22:51 -0700
Message-ID: <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com> (sfid-20121024_232256_554200_55DD4CBD)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

can you please repeat this experiment but dump the TSF32/TSF64 fields
there as hexadecimal, rather than decimal?

I'd like to see if this is an example of "bad TSF32->TSF64 promotion".



adrian
