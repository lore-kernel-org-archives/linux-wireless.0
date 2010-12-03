Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50683 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0LCPAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 10:00:11 -0500
Date: Fri, 3 Dec 2010 09:55:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	me@bobcopeland.com, mcgrof@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org, br1@einfach.org, sedat.dilek@googlemail.com
Subject: Re: [PATCH 1/6] ath5k: Always write tx powertable on hw
Message-ID: <20101203145558.GA2348@tuxdriver.com>
References: <20101203040300.GA2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101203040300.GA2988@makis.mantri>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 06:03:00AM +0200, Nick Kossifidis wrote:
>  * By skipping tx power table calibration we also skip setting
>  tx power table on hw. Make sure we always write tx power table
>  on hw since it gets cleared on reset.
> 
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Hey, Nick -- just a process note...

All your patches have " Signed-off-by..." (notice the leading space),
which looks a bit funny.  Could you figure-out why this is happening
and change it to remove the leading space?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
