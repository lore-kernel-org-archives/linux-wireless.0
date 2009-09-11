Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:44236 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZIKLfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 07:35:19 -0400
Received: by vws33 with SMTP id 33so653045vws.33
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 04:35:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	 <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	 <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
	 <4AA9F22C.3090007@gmail.com>
	 <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
Date: Fri, 11 Sep 2009 07:35:22 -0400
Message-ID: <b6c5339f0909110435l2e420685y7715f3512873008e@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2009 at 3:23 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
> penalty?
>
> This is why I asked if someone can test and give measurable
> differences over this. If there really isn't then that's not strong
> point against it.

Honestly, it probably won't matter in the grand scheme of things, but I
think if you are proposing a patch that touches every hotpath in two
drivers, then you need to do the work to say "by the way, this has benefit
X which outweighs the very small (or absent) performance regression Y,
and here are the numbers.

-- 
Bob Copeland %% www.bobcopeland.com
