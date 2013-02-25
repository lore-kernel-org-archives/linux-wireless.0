Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34380 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab3BYWRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 17:17:50 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so2796998wgb.11
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 14:17:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5129ABDB.5080800@list.ru>
References: <5129ABDB.5080800@list.ru>
Date: Mon, 25 Feb 2013 14:17:49 -0800
Message-ID: <CAJ-Vmo=+gxHABq4cJhCn9Qo350Anr0ZhvJ7Nv1_r07FPXJyhWw@mail.gmail.com> (sfid-20130225_231754_773163_D36C31E3)
Subject: Re: [ath9k-devel] [RFT] ath9k_htc - please test new images
From: Adrian Chadd <adrian@freebsd.org>
To: Roman Elshin <roxmail@list.ru>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2013 21:57, Roman Elshin <roxmail@list.ru> wrote:
> AP mode with kernel-3.0.66 and TL-WN821N,
> htc_7010.fw works but data speed is very low ~100kb/s (version from
> 20121128 works fine here).

Hi!

Please try this:

http://developer.atheros.com/~adrian/htc/20130225/

* I've left the version number at 1.3, so you don't need to modify
your firmware version in ath9k_htc;
* Felix and I have fixed up the rate table handling again so it should
be using the correct rate configuration (and thus performance should
be back to normal)

Please let me know if this works better.

Thanks!



Adrian
