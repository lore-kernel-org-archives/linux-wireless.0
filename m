Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52620 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab2ECHlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:41:21 -0400
Received: by lbgc1 with SMTP id c1so93920lbg.29
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 00:41:16 -0700 (PDT)
Message-ID: <1336030874.12189.21.camel@cumari.coelho.fi> (sfid-20120503_094125_580524_BB8E9250)
Subject: Re: [PATCH] wlcore: fix memset sizes in wl1271_cmd_build_arp_rsp()
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: dcb314@hotmail.com, jj@chaosbits.net
Date: Thu, 03 May 2012 10:41:14 +0300
In-Reply-To: <1336029951-28745-1-git-send-email-coelho@ti.com>
References: <1336029951-28745-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 10:25 +0300, Luciano Coelho wrote:
> We were using the size of the pointer and not of the allocate
> structure itself in this function.  Use the size of the structure
> instead.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Oh, now I saw that Jesper had already sent a patch to fix this.  I'll
drop this one and use his patch instead.

-- 
Cheers,
Luca.

