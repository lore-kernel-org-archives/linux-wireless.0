Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:40228 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756192Ab1DFWsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 18:48:07 -0400
Message-ID: <925216.44008.qm@web161612.mail.bf1.yahoo.com>
Date: Wed, 6 Apr 2011 15:48:05 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] zd1211rw: rename CR* macros to ZD_CR*
To: "John W. Linville" <linville@tuxdriver.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110402082554.13951.17460.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> zd_usb.h conflict with CR macros in
> include/asm-generic/termbits.h. So rename CR* macros to
> ZD_CR*.
> 
> Conversion was done with using sed and then 'over 80
> character line'
> checkpatch.pl warnings and comment indents were fixed.
> 
> Reported-by: Walter Goldens <goldenstranger@yahoo.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

John, did you omit this patch on purpose?
