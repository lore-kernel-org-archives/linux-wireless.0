Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:2002 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYGUV6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 17:58:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1558888rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 14:58:08 -0700 (PDT)
Message-ID: <b6c5339f0807211458r5e9856a1l9f7e495168830d96@mail.gmail.com> (sfid-20080721_235816_038545_672550C7)
Date: Mon, 21 Jul 2008 17:58:08 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Helge Deller" <deller@gmx.de>
Subject: Re: [PATCH] ath5k: use positive logic for HP laptop LEDs
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g62vt2$akl$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080715170716.GA5785@hash.localnet> <g62vt2$akl$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 5:42 PM, Helge Deller <deller@gmx.de> wrote:
> Bob, I think your patch below somehow got truncated and you wanted to send
> this patch ?
> http://marc.info/?l=linux-wireless&m=121557127930799&w=2
>
[...]
>>
>> -     sc->led_on = 0;  /* active low */

Hmm, well it definitely didn't end there, but the version from this
thread on marc's archive wasn't truncated.  Maybe my mailer hiccuped
when CCing you?

Anyway, yep, the patch is unchanged from the earlier posting.

-- 
Bob Copeland %% www.bobcopeland.com
