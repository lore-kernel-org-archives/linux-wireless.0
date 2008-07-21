Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:34604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYGUL6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 07:58:06 -0400
Received: by an-out-0708.google.com with SMTP id d40so360452and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 04:58:03 -0700 (PDT)
Message-ID: <43e72e890807210458m2fd60fb6sb7c042cfbad17ceb@mail.gmail.com> (sfid-20080721_135814_373490_3C31226F)
Date: Mon, 21 Jul 2008 04:58:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Michael Renzmann" <mrenzmann@madwifi.org>
Subject: Re: [ath5k-devel] [PATCH] [PATCH 2/4] Remove Atheros 11n devices from ath5k
Cc: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1542.217.24.1.226.1216617177.squirrel@webmail.madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
	 <20080720024500.GR17936@ruslug.rutgers.edu>
	 <20080720024554.GS17936@ruslug.rutgers.edu>
	 <1542.217.24.1.226.1216617177.squirrel@webmail.madwifi.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 10:12 PM, Michael Renzmann
<mrenzmann@madwifi.org> wrote:
> Hi.
>
> Luis R. Rodriguez wrote:
>> Remove Atheros 11n devices from being claimed by ath5k as its
>> now handled by ath9k.
>
> I must admit that I can't tell it myself due to a lack of in-depth
> knowledge about both drivers, hence the question: why a new driver, rather
> than adding 11n support to ath5k and have a single driver for all Atheros
> chipsets?

Working on a separate driver was the way we could guarantee the *best
possible support and quality* for our drivers for users. There are
some similarities in the drivers but the architecture varies a bit.
Both drivers can use help from each other in terms of design but right
now the focus is to get users supported. We expect to talk more about
this particular topic at the summit.

  Luis
