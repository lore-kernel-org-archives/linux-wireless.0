Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:34828 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbZJJNbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 09:31:36 -0400
Received: by gxk4 with SMTP id 4so8737356gxk.8
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2009 06:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091010125824.GA18841@hash.localnet>
References: <20090621134954.GA31505@linux-m68k.org>
	 <20090621180447.GA29469@hash.localnet>
	 <20090623174616.GA3914@linux-m68k.org>
	 <20090623202541.GA3635@hash.localnet>
	 <20090625083636.GA6323@linux-m68k.org>
	 <20090705123105.GE2132@hash.localnet>
	 <20091009143922.GA7848@linux-m68k.org>
	 <20091010125824.GA18841@hash.localnet>
Date: Sat, 10 Oct 2009 09:31:00 -0400
Message-ID: <b6c5339f0910100631p14e9a685j6c4cc7649b1690a6@mail.gmail.com>
Subject: Re: 2.6.31.[12] ath5k regression
From: Bob Copeland <me@bobcopeland.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 10, 2009 at 8:58 AM, Bob Copeland <me@bobcopeland.com> wrote:
>        ATH5K_TRACE(ah->ah_sc);
>
> +       if (!change_channel)
> +               printk(KERN_DEBUG "ath5k: reset with change_channel=true\n");
> +

Of course I meant change_channel=false in the format string but what's
important is how often it is printed :)

-- 
Bob Copeland %% www.bobcopeland.com
