Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59735 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933203AbXCUR0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 13:26:08 -0400
Date: Wed, 21 Mar 2007 18:26:05 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Remove tx_timeout callback
Message-ID: <20070321182605.4fafa8eb@griffin.suse.cz>
In-Reply-To: <200702282114.26385.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<20070228203943.11473.91707.stgit@magic.sourmilk.net>
	<200702282114.26385.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Feb 2007 21:14:21 -0500, Michael Wu wrote:
> This never worked in the first place and we can't use the network watchdog
> anyway since that checks if the queue is stopped, but wireless devices can
> have many queues. TX timeouts on virtual interfaces don't really make sense
> either since they can't stall.

Okay. Let's reintroduce this when multiqueue support is implemented in
the kernel.

 Jiri

-- 
Jiri Benc
SUSE Labs
