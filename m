Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:6767 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805Ab3GCTMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:12:44 -0400
Date: Wed, 3 Jul 2013 21:15:26 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3/5] rt2x00: rt2800lib: introduce
 rt2800_eeprom_read_from_array helper
Message-ID: <20130703191526.GC2245@localhost.localdomain> (sfid-20130703_211250_802579_7982D2AB)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-4-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372269318-30233-4-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:55:16PM +0200, Gabor Juhos wrote:
> Add a new helper function and use that for reading
> single elements of various arrays in the EEPROM.
> 
> The patch does not change the current behaviour,
> but it allows to use sequential values for the
> rt2800_eeprom_word enums. The conversion will be
> implemented in a subsequent change.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

