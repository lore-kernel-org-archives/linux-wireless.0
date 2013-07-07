Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:55056 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab3GGOVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 10:21:08 -0400
Date: Sun, 7 Jul 2013 16:23:54 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH v2 13/20] rt2x00: rt2800lib: add
 default_power3 field for three-chain devices
Message-ID: <20130707142354.GM2073@localhost.localdomain> (sfid-20130707_162112_156256_1CA056B4)
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
 <1372664879-18474-14-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372664879-18474-14-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:47:52AM +0200, Gabor Juhos wrote:
> The actual code uses two default TX power values.
> This is enough for 1T and for 2T devices however
> on 3T devices another value is needed for the third
> chain.
> 
> Add a new field to struct channel_info and initialize
> it from the 'rt2800_probe_hw_mode' function. Also modify
> the 'rt2800_config_channel' to handle the new field as
> well.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
