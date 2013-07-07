Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:51080 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3GGOhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:37:32 -0400
Date: Sun, 7 Jul 2013 16:40:17 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 16/20] rt2x00: rt2800lib: enable VCO
 recalibration for RF3053
Message-ID: <20130707144017.GP2073@localhost.localdomain> (sfid-20130707_163734_674468_8B155B3E)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-17-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-17-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:55AM +0200, Gabor Juhos wrote:
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

>  	case RF3290:
> +	case RF3053:
>  	case RF5360:
Nit: sort order.
