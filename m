Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41859 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0FDTpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 15:45:13 -0400
Date: Fri, 4 Jun 2010 15:30:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Message-ID: <20100604193009.GD2492@tuxdriver.com>
References: <20100519012528.22206.77550.stgit@tt-desk>
 <20100519013147.22206.71360.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100519013147.22206.71360.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 10:31:48AM +0900, Bruno Randolf wrote:
> Allow setting TX and RX antenna configuration via nl80211/cfg80211.
> 
> The antenna configuration is defined as a bitmap of allowed antennas. This
> bitmap is 8 bit at the moment, each bit representing one antenna. If multiple
> antennas are selected, the driver may use diversity for receive and transmit.
> This allows for a simple, yet flexible configuration interface for antennas,
> while drivers may reject configurations they cannot support.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

This spawned a long thread, that isn't clearly resolved IMHO.  So, I
haven't merged it, or the other patches that follow it in this series.

Am I mistaken?  Did this get resolved?  If not, are some of the later
patches still interesting?

Unless I hear otherwise, I'll be dropping the rest of this series...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
