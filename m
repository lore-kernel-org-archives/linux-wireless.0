Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31888 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2HIVS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 17:18:26 -0400
Date: Thu, 9 Aug 2012 17:18:19 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: signedness bug in
 at76_dfu_get_state()
Message-ID: <20120809171819.00c66bee@mj> (sfid-20120809_231830_520691_479E55B1)
In-Reply-To: <20120809065730.GA7925@elgon.mountain>
References: <20120809065730.GA7925@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2012 09:57:30 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This return holds the number of bytes transfered (1 byte) or a
> negative error code.  The type should be int instead of u8.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Pavel Roskin <proski@gnu.org>

Nice catch, thanks!

-- 
Regards,
Pavel Roskin
