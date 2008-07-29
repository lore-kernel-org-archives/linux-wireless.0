Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4037 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYG3AQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 20:16:06 -0400
Date: Tue, 29 Jul 2008 16:40:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 1/12] ath5k: Update register list
Message-ID: <20080729204054.GA10188@tuxdriver.com> (sfid-20080730_021609_319249_802E8B79)
References: <20080720033041.GA7440@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080720033041.GA7440@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 06:30:41AM +0300, Nick Kossifidis wrote:
>  * Update list of registers
>  * Use updated register macros inside hw.c and initvals.c
> 
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Nick,

Some of the changes in this patch break the build unless the rest
of the series is applied, and those patches can't be applied before
applying this one.  This breaks git-bisect.  Could I trouble you
to include the pieces of this patch that break the build into those
later patches that fix the build?  Or perhaps you can simply split
this into a patch that adds new definitions and one that deletes
older definitions?  The latter could then be applied at the end of
the series.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
