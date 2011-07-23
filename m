Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40722 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1GWU5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 16:57:11 -0400
Message-ID: <20110723165710.jso0g99twk80gcsg-cebfxv@webmail.spamcop.net> (sfid-20110723_225734_815143_2CF3C8B6)
Date: Sat, 23 Jul 2011 16:57:10 -0400
From: Pavel Roskin <proski@gnu.org>
To: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath5k: merge ath5k_hw and ath5k_softc
References: <20110715002155.14332.3527.stgit@mj.roinet.com>
	<CAFtRNNy3SvLXUJ8uaOibGfnynS7gwCOMW2x=cLhfPDf9aNw4vQ@mail.gmail.com>
	<CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
	<4E2733BC.3070309@gnu.org> <20110720200004.GB18231@tuxdriver.com>
	<20110720175918.5diz6j1a9a8sk04w-cebfxv@webmail.spamcop.net>
	<CA+icZUW8Y1SDTJYbqUSdCznU4pVpNe4nQksdNb+rXCuqvBguoA@mail.gmail.com>
In-Reply-To: <CA+icZUW8Y1SDTJYbqUSdCznU4pVpNe4nQksdNb+rXCuqvBguoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Sedat Dilek <sedat.dilek@googlemail.com>:

> On Wed, Jul 20, 2011 at 11:59 PM, Pavel Roskin <proski@gnu.org> wrote:
>> The remaining changes are minimal and will be submitted separately.
>
> Just a friendly reminder for the missing part v2 -> v3.

It sits in my stgit queue.  It just didn't gather the critical mass to  
be submitted.  The cleanup of the includes should be more systematic.   
  When I see the headers, I always find something more important to  
clean up than the includes.

As for renaming the functions, I think it can create some confusion.   
We have too many functions with "init" and start" in their names.   
It's hard to distinguish ath_init_hw from ath_init_ah.  I want to make  
sure that the new names would stand out.

-- 
Regards,
Pavel Roskin
