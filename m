Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32946 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbcGSSjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:39:31 -0400
Date: Tue, 19 Jul 2016 11:39:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the
 wireless-drivers-next tree
Message-ID: <20160719183913.GA88186@google.com> (sfid-20160719_203944_134517_E563203C)
References: <20160719160831.79c0303f@canb.auug.org.au>
 <8760s2w369.fsf@kamboji.qca.qualcomm.com>
 <CACna6rxVFD1MpAEYP_Zd4W8CvgnxSQpa0wJs83jwDJ5v11gZ=Q@mail.gmail.com>
 <871t2qw1cz.fsf@kamboji.qca.qualcomm.com>
 <CACna6ry6QgrbUoHuJacmr1EhHZyrwqsXfr51gENvY-0zM9L+3Q@mail.gmail.com>
 <87h9blvhxg.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87h9blvhxg.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to head this off, since I noticed it...

On Tue, Jul 19, 2016 at 05:08:59PM +0300, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> > I sent a patch seconds ago, you may just take a look at it. If you
> > still prefer to revert my commit, go ahead.
> 
> Ok, let's try your fix. We still have few days. I applied the patch[1]
> to the pending branch this morning and if I don't see any errors I apply
> it later tonight and hopefully it will be in tomorrow's linux-next
> build. Thanks for the quick fix, very much appreciated.
> 
> [1] "mtd: add arch dependency for MTD_BCM47XXSFLASH symbol"
>     https://patchwork.kernel.org/patch/9236053/

I applied a trivial change to this same Kconfig entry:

Subject: mtd: update description of MTD_BCM47XXSFLASH symbol
http://git.infradead.org/l2-mtd.git/commitdiff/0a526341fee054c1e2b9f0e4b2b424ae81707d4c

It's a trivial conflict, so should we just let Linus work it out? I can
note it my MTD pull request, if wireless lands first.

Brian
