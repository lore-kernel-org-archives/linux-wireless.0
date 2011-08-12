Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1HLTcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:32:03 -0400
Date: Fri, 12 Aug 2011 12:31:56 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] staging: remove ath6kl
Message-ID: <20110812193156.GA10770@suse.de> (sfid-20110812_213206_496194_8C476F13)
References: <20110812173255.GE14182@suse.de>
 <1313176080-21794-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313176080-21794-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 10:08:00PM +0300, Kalle Valo wrote:
> ath6kl is now in drivers/net/wireless/ath so the staging driver
> is not supported anymore and should be removed.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Greg KH <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

