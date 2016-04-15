Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58429 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcDOSft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:35:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/7] mwifiex: scan: simplify dereference of bss_desc fields
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1457599451-13910-2-git-send-email-afenkart@gmail.com>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Andreas Fenkart <afenkart@gmail.com>
Message-Id: <20160415183548.848B160452@smtp.codeaurora.org> (sfid-20160415_203603_183269_655168B4)
Date: Fri, 15 Apr 2016 18:35:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> given this structure:
> struct foo {
>   struct bar {
>      int baz;
>   }
> }
> 
> these accesses are equivalent:
> (*(foo->bar)).baz
> foo->bar->baz
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

0a233c98a8e9 mwifiex: scan: simplify dereference of bss_desc fields
38329568c3f7 mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
2ccf7cef0cf9 mwifiex: scan: simplify ternary operators using gnu extension
679b687bc96d mwifiex: scan: factor out dbg_security_flags
948ad6b34943 mwifiex: scan: replace pointer arithmetic with array access
c70ca8cb9a7c mwifiex: factor out mwifiex_cancel_pending_scan_cmd
85abfb1239ec mwifiex: make mwifiex_insert_cmd_to_free_q local static

Kalle Valo
