Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52814 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab0BIRKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 12:10:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 09:10:07 -0800
Date: Tue, 9 Feb 2010 09:10:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Zhang Yanfei-B21500 <B21500@freescale.com>
CC: Jinsung Lee <ljs@netsys.kaist.ac.kr>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] can ath9k run on linux 2.6.25
Message-ID: <20100209171005.GB16748@tux>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
 <25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net>
 <43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com>
 <02a001caa94e$87b9bb80$972d3280$@kaist.ac.kr>
 <25E8B46727291E4EB5A1CB88CBC4284E0100A779@zmy16exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <25E8B46727291E4EB5A1CB88CBC4284E0100A779@zmy16exm21.fsl.freescale.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 08, 2010 at 10:36:09PM -0800, Zhang Yanfei-B21500 wrote:
> Hi Guys
> 
>         Thanks a lot... Good news. Do you have porting to 2.6.25
> successfully with good performace also ?

It should be OK for the release without the multiqueue backported.
Multiqueue was added back on the 2.6.32.4 release so 2.6.32.3 should
be the last release without it. That I believe was tested to work
well with ath9k.

After that I have not received any feedback with respect to the multiqueue
backport. Feedback on that is appreciated.

> I am going to porting it to a powerpc board base on 2.6.25 kernel.

You should not need to do much but just test. Can you please let me know.

This one should just work:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.3.tar.bz2

Newer stable kernels after this required multiqueue backported which I
gave a try but haven't gotten reports from users on:

http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.32.5-rc3.tar.bz2

  Luis
