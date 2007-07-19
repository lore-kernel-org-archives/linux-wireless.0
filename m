Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4626 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763373AbXGSTdV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 15:33:21 -0400
Date: Thu, 19 Jul 2007 15:10:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH 1/2] zd1211rw-mac80211: return hardware specific tx rate code for rx status
Message-ID: <20070719191002.GB6603@tuxdriver.com>
References: <20070611103828.961999956@warmcat.com> <20070611103914.481787013@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070611103914.481787013@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2007 at 11:38:29AM +0100, andy@warmcat.com wrote:
> zd1211rw-mac80211 uses different hardware-specific codings to talk about
> rates when doing transmit and receive.  Because mac80211 looks up the rx
> rate against the rates table used for selecting hardware-specific coding for
> tx, the rate returned in the rx_status struct needs to be adjusted to use the
> coding used to hardware-specific tx rates.  This patch performs this adjustment.
> 
> Without this patch the radiotap-based monitor stuff reports a "0.0Mbps" rate for
> all packets from this driver.
> 
> CC: Daniel Drake <dsd@gentoo.org>
> CC: Ulrich Kunitz <kune@deine-taler.de>
> Signed-off-by: Andy Green <andy@warmcat.com>

Daniel, Uli -- ack/nak?

-- 
John W. Linville
linville@tuxdriver.com
