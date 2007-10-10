Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3293 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbXJJSI1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 14:08:27 -0400
Date: Wed, 10 Oct 2007 13:33:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Markus Feldmann <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Patch for Kernel and Ath5k
Message-ID: <20071010173343.GI5962@tuxdriver.com> (sfid-20071010_190833_152076_D6EAA0F6)
References: <feieb9$nvg$1@sea.gmane.org> <200710102132.21790.bruno@thinktube.com> <feih2c$21f$1@sea.gmane.org> <200710101502.20202.hs4233@mail.mn-solutions.de> <feike5$fod$1@sea.gmane.org> <feisop$i4m$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <feisop$i4m$1@sea.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 05:57:13PM +0200, Markus Feldmann wrote:

> I do not find the Entry,
> <M> Generic IEEE 802.11 Networking Stack (mac80211)
> in the ".config" File.
> And i do not find any files in the Sources containig ATH5k?

config ATH5K
        tristate "Atheros 5xxx wireless cards support"
        depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL

Did you select EXPERIMENTAL?

John
-- 
John W. Linville
linville@tuxdriver.com
