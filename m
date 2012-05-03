Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52554 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab2ECMx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 08:53:59 -0400
Received: by lbok6 with SMTP id k6so1686390lbo.18
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 05:53:57 -0700 (PDT)
Message-ID: <1336049634.12189.28.camel@cumari.coelho.fi> (sfid-20120503_145404_091966_70E2A082)
Subject: Re: [patch] wlcore: release lock on error in wl1271_op_suspend()
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 03 May 2012 15:53:54 +0300
In-Reply-To: <20120416105702.GA25234@elgon.mountain>
References: <20120416105702.GA25234@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-16 at 13:57 +0300, Dan Carpenter wrote:
> We should release this lock before returning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks Dan!

