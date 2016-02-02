Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32775 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbcBBPHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:07:04 -0500
Message-ID: <1454425622.2926.6.camel@sipsolutions.net> (sfid-20160202_160709_603179_1733E293)
Subject: Re: [PATCH v2] mac80211: expose txq queue depth and size to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 02 Feb 2016 16:07:02 +0100
In-Reply-To: <1453904772-25289-1-git-send-email-michal.kazior@tieto.com> (sfid-20160127_152508_654339_7FE9E06C)
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	 <1453904772-25289-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160127_152508_654339_7FE9E06C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 15:26 +0100, Michal Kazior wrote:
> This will allow drivers to make more educated
> decisions whether to defer transmission or not.
> 
> Relying on wake_tx_queue() call count implicitly
> was not possible because it could be called
> without queued frame count actually changing on
> software tx aggregation start/stop code paths.
> 
> It was also not possible to know how long
> byte-wise queue was without dequeueing.
> 
Applied.

johannes
