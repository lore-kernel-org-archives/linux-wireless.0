Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2G0JyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 05:54:12 -0400
Message-ID: <1343382848.4449.2.camel@jlt3.sipsolutions.net> (sfid-20120727_115416_008260_C447C064)
Subject: Re: [PATCH 0/2] wlcore tx rework
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, coelho <coelho@ti.com>
Date: Fri, 27 Jul 2012 11:54:08 +0200
In-Reply-To: <1343373093-10065-1-git-send-email-arik@wizery.com> (sfid-20120727_091140_338313_49C6C009)
References: <1343373093-10065-1-git-send-email-arik@wizery.com>
	 (sfid-20120727_091140_338313_49C6C009)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 10:11 +0300, Arik Nemtsov wrote:
> Get the hlid of a queued skb from driver internal info instead of the
> sta inside the skb cb. Rework some functions so that the sta is passed
> explicitly during op_tx.
> 
> Testd in STA + AP modes.
> 
> Johannes - would you like to take these via your tree, as a prerequisite
> for Thomas' patch?

I think I will if nobody objects (Luca? John?), rather than trying to
organise this with multiple trees.

johannes

