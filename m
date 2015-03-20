Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTHAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 03:00:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: missing curly braces in mwifiex_write_data_complete()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150318082235.GC10434@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20150320070019.9A289140DB9@smtp.codeaurora.org> (sfid-20150320_080025_165128_1FB54AD9)
Date: Fri, 20 Mar 2015 07:00:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> It's clear from the indenting that curly braces were intended here.
> 
> Fixes: e35000ead491 ('mwifiex: preprocess packets from TX queue')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
