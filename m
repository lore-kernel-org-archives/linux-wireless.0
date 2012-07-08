Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:58436 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366Ab2GHNMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 09:12:30 -0400
Received: by lbbgm6 with SMTP id gm6so16744129lbb.5
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 06:12:27 -0700 (PDT)
Message-ID: <1341753145.4354.41.camel@cumari.coelho.fi> (sfid-20120708_151235_128729_C3314854)
Subject: Re: [patch] wlcore: fix a couple small memory leaks
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	Eliad Peller <eliad@wizery.com>, Ido Yariv <ido@wizery.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 08 Jul 2012 16:12:25 +0300
In-Reply-To: <20120630120755.GC22767@elgon.mountain>
References: <20120630120755.GC22767@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-30 at 15:07 +0300, Dan Carpenter wrote:
> We should free "chunk" here before returning the error code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied and pushed, thanks a lot, Dan!

--
Luca.

