Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0DLHl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:41:27 -0400
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to
 band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100412073703.28078.90501.stgit@tt-desk>
References: <20100412073658.28078.32155.stgit@tt-desk>
	 <20100412073703.28078.90501.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 09:41:22 +0200
Message-ID: <1271058082.3877.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 16:37 +0900, Bruno Randolf wrote:
> When we create an IBSS we are can define the basic rates according to the band
> in use. Previously only the B mode rates (1 and 2Mbps) were used
> unconditionally, which resulted in low thruput when using RTS/CTS.
> 
> Also we should save the IBSS basic rates configuration when we join an IBSS.

Again, this breaks things. If you feel this is necessary for some
reason, it needs to be configurable during the IBSS join by userspace.

johannes

