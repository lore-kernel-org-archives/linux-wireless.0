Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1748 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0H3Ssu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 14:48:50 -0400
Date: Mon, 30 Aug 2010 14:42:16 -0400
From: me@bobcopeland.com
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] ath5k: eliminate warning unintialized variable warning
Message-ID: <20100830184216.GA12630@hash.localnet>
References: <1283191913-3155-1-git-send-email-linville@tuxdriver.com> <1283192516-3324-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1283192516-3324-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 02:21:56PM -0400, John W. Linville wrote:
> ath5k/base.c:1317: warning: ‘ret’ may be used uninitialized in this function
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, 

Acked-by: Bob Copeland <me@bobcopeland.com>

The first one was cc: stable, do we need to do that too or just
give them a rolled up patch?

-- 
Bob Copeland %% www.bobcopeland.com

