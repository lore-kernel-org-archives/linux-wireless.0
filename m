Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34375 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYGXV2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:28:55 -0400
Subject: Re: [PATCH 3/12] ath5k: Misc hw_attach fixes
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mick@madwifi.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <20080720033439.GC7440@makis>
References: <20080720033439.GC7440@makis>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 17:28:53 -0400
Message-Id: <1216934933.3094.11.camel@dv> (sfid-20080724_232857_069962_9D5707D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-20 at 06:34 +0300, Nick Kossifidis wrote:
>  #define AR5K_SREV_RAD_5112A	0x35
> +#define	AR5K_SREV_RAD_5112B	0x36

Please avoid tabs after "#define"

Apart from that, it looks good.

-- 
Regards,
Pavel Roskin
