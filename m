Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:57551 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0BIGQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 01:16:57 -0500
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: "'Luis R. Rodriguez'" <mcgrof@gmail.com>,
	"'Zhang Yanfei-B21500'" <B21500@freescale.com>
Cc: <ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com> 	<25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net> <43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com>
In-Reply-To: <43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com>
Subject: RE: [ath9k-devel] can ath9k run on linux 2.6.25
Date: Tue, 9 Feb 2010 15:10:08 +0900
Message-ID: <02a001caa94e$87b9bb80$972d3280$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luis,

Is this tarball also working on kernel 2.6.24?

I've been trying, but it may have some problem.

Thanks.


-Jinsung

-----Original Message-----
From: ath9k-devel-bounces@lists.ath9k.org [mailto:ath9k-devel-bounces@lists.ath9k.org] On Behalf Of Luis R. Rodriguez
Sent: Tuesday, February 09, 2010 3:02 AM
To: Zhang Yanfei-B21500
Cc: ath9k-devel@venema.h4ckr.net; linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] can ath9k run on linux 2.6.25

On Mon, Feb 8, 2010 at 1:20 AM, Zhang Yanfei-B21500
<B21500@freescale.com> wrote:
> Hi All
>        Anyone have porting the ath9k to 2.6.25? Is it can work on
> 2.6.25?
>

This tarball has 2.6.25 enabled:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.3.tar.bz2

Newer stable kernels after this required multiqueue backported which I
gave a try but haven't gotten reports from users on:

http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.32.5-rc3.tar.bz2

After untarring you will have to select to compile only ath9k:

./scripts/driver-select ath9k

  Luis
_______________________________________________
ath9k-devel mailing list
ath9k-devel@lists.ath9k.org
https://lists.ath9k.org/mailman/listinfo/ath9k-devel

