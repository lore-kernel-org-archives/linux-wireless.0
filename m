Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37729 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2KLTkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:40:15 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so9588871iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:40:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121112192859.GB6842@localhost>
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
	<CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
	<20121112192859.GB6842@localhost>
Date: Mon, 12 Nov 2012 11:40:15 -0800
Message-ID: <CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com> (sfid-20121112_204020_465775_D17EF841)
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
From: Sam Leffler <sleffler@google.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 11:28 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Nov 12, 2012 at 11:17:36AM -0800, Adrian Chadd wrote:
> [undid top-post]
>> On 12 November 2012 10:53, Thomas Pedersen <thomas@cozybit.com> wrote:
>> > This is true for at least AR5213, and shouldn't be different for other
>> > ath5k PHYs.
>>
>> It may be; that's the problem. :/
>
> I'll do some testing tonight with whatever cards I have around here to
> see if we can at least get a better idea of which chipsets do what.

>From my experience doing tdma on ath chipsets I know the timestamp is
a snapshot of the tsf recorded by the dma engine when it writes the
descriptor on dma completion.  This was only legacy frames; don't know
how things work for aggregate frames.

>
> --
> Bob Copeland %% www.bobcopeland.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
