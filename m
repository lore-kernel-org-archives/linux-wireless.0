Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:49043 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762281AbYAKRxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 12:53:37 -0500
Date: Fri, 11 Jan 2008 18:53:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: j@w1.fi, linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hostap: section mismatch warning
Message-ID: <20080111175340.GA28624@uranus.ravnborg.org> (sfid-20080111_175401_598556_5A130DFF)
References: <20080110143130.7efb2460.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080110143130.7efb2460.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 10, 2008 at 02:31:30PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch by changing variable name to match one of the
> whitelisted (allowable) names for pointing into init data:
> 
> WARNING: vmlinux.o(.data+0xce618): Section mismatch: reference to .init.data:prism2_plx_id_table (between 'prism2_plx_drv_id' and 'dev_info')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks for doing this work Randy.

	Sam
