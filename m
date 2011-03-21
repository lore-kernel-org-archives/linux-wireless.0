Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42095 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675Ab1CURdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 13:33:20 -0400
Received: by wyb42 with SMTP id 42so6179147wyb.32
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 10:33:09 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix a couple of sparse warning about
 undeclared functions
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1300728451-14491-1-git-send-email-coelho@ti.com>
References: <1300728451-14491-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 19:32:29 +0200
Message-ID: <1300728749.2593.243.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 19:27 +0200, Luciano Coelho wrote:
> Fix the following sparse warnings:
> 
> drivers/net/wireless/wl12xx/main.c:1129:5: warning: symbol '__wl1271_plt_stop' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/main.c:2988:5: warning: symbol 'wl1271_op_ampdu_action' was not declared. Should it be static?
> 
> Both functions should be static.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

