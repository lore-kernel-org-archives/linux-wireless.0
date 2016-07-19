Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbcGSXgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 19:36:44 -0400
Date: Wed, 20 Jul 2016 09:36:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the
 wireless-drivers-next tree
Message-ID: <20160720093641.2dbb1f83@canb.auug.org.au> (sfid-20160720_013704_746639_C8A71D04)
In-Reply-To: <20160719183913.GA88186@google.com>
References: <20160719160831.79c0303f@canb.auug.org.au>
	<8760s2w369.fsf@kamboji.qca.qualcomm.com>
	<CACna6rxVFD1MpAEYP_Zd4W8CvgnxSQpa0wJs83jwDJ5v11gZ=Q@mail.gmail.com>
	<871t2qw1cz.fsf@kamboji.qca.qualcomm.com>
	<CACna6ry6QgrbUoHuJacmr1EhHZyrwqsXfr51gENvY-0zM9L+3Q@mail.gmail.com>
	<87h9blvhxg.fsf@kamboji.qca.qualcomm.com>
	<20160719183913.GA88186@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

On Tue, 19 Jul 2016 11:39:13 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
>
> I applied a trivial change to this same Kconfig entry:
> 
> Subject: mtd: update description of MTD_BCM47XXSFLASH symbol
> http://git.infradead.org/l2-mtd.git/commitdiff/0a526341fee054c1e2b9f0e4b2b424ae81707d4c
> 
> It's a trivial conflict, so should we just let Linus work it out? I can
> note it my MTD pull request, if wireless lands first.

Linus and I should be able to cope.  I will send my usual notification today.

-- 
Cheers,
Stephen Rothwell
