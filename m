Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:56862 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3GGOMX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:12:23 -0400
Date: Sun, 7 Jul 2013 16:15:09 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 10/20] rt2x00: rt2800lib: introduce
 rt2800_get_txmixer_gain_{24, 5}g helpers
Message-ID: <20130707141509.GF2073@localhost.localdomain> (sfid-20130707_161225_805026_80F8286D)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-11-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-11-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:49AM +0200, Gabor Juhos wrote:
> Move the TX mixer gain reading code into separate
> helper functions in preparation for RT3593 support.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
