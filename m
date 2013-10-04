Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:33121 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab3JDOFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:05:21 -0400
Date: Fri, 4 Oct 2013 16:06:44 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Paul Menzel <paulepanter@users.sourceforge.net>
Subject: Re: [rt2x00-users] [PATCH v2 1/2] rt2x00: rt2800lib: remove
 TXMIXER_GAIN entries from the extended EEPROM map
Message-ID: <20131004140644.GC32428@localhost.localdomain> (sfid-20131004_160525_226004_F435719D)
References: <1380802022-28646-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380802022-28646-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 02:07:01PM +0200, Gabor Juhos wrote:
> The comments are indicating that the TXMIXER_GAIN_BG
> and TXMIXED_GAIN_A entries are overlapping with the
> RSSI_BG2 and RSSI_A2 entries in the extended EEPROM
> map. This is not correct, because the upper byte of
> the RSSI_BG2 and RSSI_A2 entries are reserved. There
> are no TX mixer gain values are stored at all in the
> extended EEPROM.
> 
> Remove the initialization of these entries from the
> extended EEPROM map to reflect this.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
