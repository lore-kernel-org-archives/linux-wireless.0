Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbXERXFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 19:05:54 -0400
Date: Sat, 19 May 2007 00:05:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Message-ID: <20070518230551.GB29062@infradead.org>
References: <464B7B7C.5080800@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464B7B7C.5080800@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2007 at 02:45:32PM -0700, James Ketrenos wrote:
> drivers/net/wireless/mac80211/Kconfig              |    1 +
> drivers/net/wireless/mac80211/Makefile             |    1 +
> drivers/net/wireless/mac80211/iwlwifi/Kconfig      |   96 +
> drivers/net/wireless/mac80211/iwlwifi/Makefile     |   27 +
> drivers/net/wireless/mac80211/iwlwifi/base.c       | 8146 

You're not reading linux-wireless a lot, are you?  The last
driver submission got a pretty clear answer that there should not
be a drivers/net/wireless/mac80211/ subdirectory.

