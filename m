Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4077 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbXH3NOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:14:42 -0400
Date: Thu, 30 Aug 2007 08:40:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
Message-ID: <20070830124054.GC5140@tuxdriver.com>
References: <2713029743177393055@pripojeni.net> <2440910618305782004@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2440910618305782004@pripojeni.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
> ath5k, use int as retval
> 
> Convert some functions to return int and proper negative return value on
> error as we are used to.

Since I didn't apply 1/5, this one didn't apply either.  It seems
fine overall, so if you rediff I'll be happy to apply.

John
-- 
John W. Linville
linville@tuxdriver.com
