Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:63386 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZFFDAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 23:00:16 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1171372ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 20:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 5 Jun 2009 19:59:57 -0700
Message-ID: <43e72e890906051959j6ed6ad7et1290680d5059064d@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] ath9k: few rate control cleanups
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2009 at 5:03 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> Addressed the few comments and tested compile against PID this
> time and when disabling ath9k debug. This time around we just
> make the settings for low rate on management frames and no-ack
> frames a helper and let rate control algorithms use it. When
> we want to extend these the helper just can be lifted.

all-in-one patch available at:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/06-05/rc3.patch

  Luis
