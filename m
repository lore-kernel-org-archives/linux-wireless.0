Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43462 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbCGIeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:34:21 -0500
Received: by wibhm9 with SMTP id hm9so8592771wib.2
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2015 00:34:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54F9C7B1.3090406@neratec.com>
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
 <54F99C9B.7000901@neratec.com> <CAGnRvuppmXMZpgsQaK0XPcourRjfxU4KMjB7RxoZ05QjHF6isg@mail.gmail.com>
 <54F9A41F.4090505@neratec.com> <CAGnRvuqpD6YHS6wJFR5J3n0sQqM3cfKYcydE4wYE52eiZjZeDA@mail.gmail.com>
 <54F9C7B1.3090406@neratec.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Sat, 7 Mar 2015 09:33:59 +0100
Message-ID: <CAGnRvurnHCjrxsDwLPAzrssxCZnG2ULpy0vZL154sQ+M7TSkBQ@mail.gmail.com> (sfid-20150307_093829_285646_46BD10DF)
Subject: Re: State of DFS with Mac80211/ath9k
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2015 at 4:28 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 03/06/2015 03:33 PM, Henning Rogge wrote:
>>
>> Is there a way to make the kernel export the pulse patterns when a
>> radar event is detected to do some debugging what was going on?
>>
>
> Anyway, you should compile ath9k with debugging support (which you most probably
> already did) and enable DFS debugging by setting ATH_DBG_DFS (0x00010000) in
> /sys/kernel/debug/ieee80211/phy0/ath9k/debug
>
> This will give debug output per individual pulse and detector results and allow to
> understand why the detector triggered.
>
> Also if not already known, there is a dfs_stats file in the same debugfs directory
> providing global DFS counters.
>
>
> Hope it helps, have a nice weekend.

I already found the dfs_stats file, but the DFS debugging sounds
interesting. Thank you for the hint.

Henning Rogge
