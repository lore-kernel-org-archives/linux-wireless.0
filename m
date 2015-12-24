Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34728 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbbLXG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 01:59:42 -0500
Date: Thu, 24 Dec 2015 09:59:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: glen lee <glen.lee@atmel.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	Tony Cho <tony.cho@atmel.com>, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH] staging: wilc1000: remove wilc_sdio_init
Message-ID: <20151224065934.GA5284@mwanda> (sfid-20151224_075945_877049_69465181)
References: <1450838003-24379-1-git-send-email-glen.lee@atmel.com>
 <CAGRGNgWrFdRYXg+912stL9fcYE2ZqbEzNoOiHnyjYvX+5BHR=A@mail.gmail.com>
 <567B6140.1090907@atmel.com>
 <CAGRGNgUv66UgjxA=Yoxy-+9FRpcVOixxc2pPRkWYQxe0ye5J=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgUv66UgjxA=Yoxy-+9FRpcVOixxc2pPRkWYQxe0ye5J=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I kind of feel like we have started to err on the side of breaking
things up into too many patches.  Linus has said the same thing...
This patch is not hard to review, except that the title was bad.

Originally it was sent as:

[PATCH] staging: wilc1000: fix bug in sdio/spi

which is the correct title, but the Fixes tag was in the wrong format so
Greg rejected it.  Now the Fixes tag is missing entirely which is
useless and it is disguised as a cleanup.  Cleanup patches should not
change run time and fixes should be marked clearly.

regards,
dan carpenter

