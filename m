Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37169 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3JDOFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 10:05:42 -0400
Date: Fri, 4 Oct 2013 16:07:02 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Paul Menzel <paulepanter@users.sourceforge.net>
Subject: Re: [rt2x00-users] [PATCH v2 2/2] rt2x00: rt2800lib: remove
 TXPOWER_DELTA entry from extended EEPROM map
Message-ID: <20131004140702.GD32428@localhost.localdomain> (sfid-20131004_160546_223287_2A821DB7)
References: <1380802022-28646-1-git-send-email-juhosg@openwrt.org>
 <1380802022-28646-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380802022-28646-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 03, 2013 at 02:07:02PM +0200, Gabor Juhos wrote:
> The TXPOWER_DELTA field of the regular EEPROM
> stores the TX power compensation value for HT40.
> The extended EEPROM has no such field, it stores
> separate TX power values for HT20 and for HT40.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
