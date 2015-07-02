Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33976 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbGBOcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 10:32:20 -0400
Received: by oigx81 with SMTP id x81so57081067oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 07:32:19 -0700 (PDT)
Date: Thu, 2 Jul 2015 09:31:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Wei Zhong <wzhong@google.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
Message-ID: <20150702143144.GB40677@ubuntu-hedt> (sfid-20150702_163224_493811_6596FC7C)
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
 <20150702134801.GA40677@ubuntu-hedt>
 <CAHr=Vqn8LzpsbAk=V2yC3Q0Xd5DHqfuSCW4G6vs1vZqBG-VSMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHr=Vqn8LzpsbAk=V2yC3Q0Xd5DHqfuSCW4G6vs1vZqBG-VSMw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 02, 2015 at 07:21:30AM -0700, Wei Zhong wrote:
> Thanks for the reply. I'll fix the format and re-submit.

Thanks.

> > Why isn't 80MHz channel bandwidth allowed in the 5650-5730 range?
> 
> It could. But since the entire band is only 80 MHz, in practice, not a single
> center_freq, channel 136 or140 for example, can utilities 80 MHz, right?

I don't know, that's why I asked :-)

I actually haven't read up yet on how VHT80 is done in practice. I was
just curious why an 80 MHz channel wouldn't be possible when there's the
space for it.

Thanks,
Seth
