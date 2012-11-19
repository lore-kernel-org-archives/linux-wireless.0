Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2KSRCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 12:02:52 -0500
Message-ID: <1353344601.18299.31.camel@jlt4.sipsolutions.net> (sfid-20121119_180256_467235_AAF278DF)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 18:03:21 +0100
In-Reply-To: <1353343170-26516-9-git-send-email-eliad@wizery.com> (sfid-20121119_173952_507956_82E60242)
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-9-git-send-email-eliad@wizery.com>
	 (sfid-20121119_173952_507956_82E60242)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
> Add some basic chanctx implementation.

This patch will leave the driver in a broken state, and in fact probably
crashing trying to use hw.conf.channel.

johannes

