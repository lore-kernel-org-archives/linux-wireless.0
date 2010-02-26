Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936134Ab0BZNV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 08:21:26 -0500
Subject: Re: [PATCH] libertas: add auto auth mode feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
In-Reply-To: <1267189710.18491.60.camel@violet>
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
	 <1267189710.18491.60.camel@violet>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 14:21:22 +0100
Message-ID: <1267190482.3868.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-26 at 14:08 +0100, Marcel Holtmann wrote:

> However from a different point, how can you try open mode first and
> detect a failure. Isn't this suppose to be the other way around, try
> shared first and then fall back to open?

No, why? If open doesn't get rejected, it should be ok to use.

johannes

