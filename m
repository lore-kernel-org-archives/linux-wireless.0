Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3670 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXFKVyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 17:54:38 -0400
Date: Mon, 11 Jun 2007 17:20:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: Don't stop tx queue on master device while scanning.
Message-ID: <20070611212021.GJ10397@tuxdriver.com>
References: <200706081531.14086.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200706081531.14086.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 03:31:13PM +0200, Ivo van Doorn wrote:
> From: Mattias Nissler <mattias.nissler@gmx.de>
> 
> mac80211 stops the tx queues during scans. This is wrong with respect
> to the master deivce tx queue, since stopping it prevents any probes
> from being sent during the scan. Instead, they accumulate in the queue
> and are only sent after the scan is finished, which is obviously
> wrong.

Can I get a quick ACK/NAK on this one from the mac80211 guys?

John
-- 
John W. Linville
linville@tuxdriver.com
