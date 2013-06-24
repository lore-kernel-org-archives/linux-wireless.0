Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:41882 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3FXPpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:45:03 -0400
Date: Mon, 24 Jun 2013 17:47:28 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	stable@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] rt2x00: read 5GHz TX power values from
 the correct offset
Message-ID: <20130624154728.GA2460@localhost.localdomain> (sfid-20130624_174507_910219_8C38ECF3)
References: <1371899605-30513-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371899605-30513-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 01:13:25PM +0200, Gabor Juhos wrote:
> The current code uses the same index value both
> for the channel information array and for the TX
> power table. The index starts from 14, however the
> index of the TX power table must start from zero.
> 
> Fix it, in order to get the correct TX power value
> for a given channel.
> 
> The changes in rt61pci.c and rt73usb.c are compile
> tested only.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Cc: stable@vger.kernel.org

Nice catch.

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

