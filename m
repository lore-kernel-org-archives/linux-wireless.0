Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbcASIYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 03:24:23 -0500
Date: Tue, 19 Jan 2016 09:22:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eli Cooper <elicooper@gmx.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] rt2x00: fix monitor mode regression
Message-ID: <20160119082258.GA3340@redhat.com> (sfid-20160119_092427_047270_77EBF351)
References: <1453116619-29933-1-git-send-email-elicooper@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453116619-29933-1-git-send-email-elicooper@gmx.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2016 at 07:30:19PM +0800, Eli Cooper wrote:
> Since commit df1404650ccb ("mac80211: remove support for IFF_PROMISC")
> monitor mode for rt2x00 has been made effectively useless because the
> hardware filter is configured to drop packets whose intended recipient is
> not the device, regardless of the presence of monitor mode interfaces.
> 
> This patch fixes this regression by adding explicit monitor mode support,
> and by configuring the hardware filter accordingly.
> 
> Changes in v3:
>   introduce and use CONFIG_MONITORING in rt2x00_state_flags
>   remove unnecessary debug messages
>   improve patch format
> 
> Changes in v2:
>   fix patch format
> 
> Signed-off-by: Eli Cooper <elicooper@gmx.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
