Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51931 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZHJUbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 16:31:17 -0400
Date: Mon, 10 Aug 2009 16:26:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Fix read buffer overflow
Message-ID: <20090810202622.GB6060@tuxdriver.com>
References: <4A7CA188.1070706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A7CA188.1070706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2009 at 11:50:00PM +0200, Roel Kluin wrote:
> Prevent a read of powInfo[-1] in the first iteration.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> The last hunk I already sent in a previous patch.

The last two hunks, apparently -- neither of them apply.

Why on earth would you randomly include those hunks here?  Especially
if you already sent them?

Listen, I'm glad you are there to do these various clean-ups.
But honestly your patches seem to always have some problem that
requires manual intervention to apply them.  You make my life hard,
and you slow me down.  That makes John a grumpy boy.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
