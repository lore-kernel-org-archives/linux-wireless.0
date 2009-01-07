Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbZAGVAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 16:00:39 -0500
Date: Wed, 7 Jan 2009 15:58:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/6] mac80211: remove an unnecessary assignment to info
	in __ieee80211_tx().
Message-ID: <20090107205855.GC4387@tuxdriver.com> (sfid-20090107_220053_553011_CFB9D4F3)
References: <eb3ff54b0901060050g475209d2m75ee43baa0af89c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eb3ff54b0901060050g475209d2m75ee43baa0af89c0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 10:50:33AM +0200, Rami Rosen wrote:
> This patch removes an unnecessary assignment to info
> in __ieee80211_tx() , tx.c.
> 
> (wireless-testing).
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

BTW, would you mind not putting "(wireless-testing)" or similar stuff
in the changelog?  It can be handy to know, but you should put it
after the Signed-off-by and after a line starting with "---":

	This patch removes an unnecessary assignment to info
	in __ieee80211_tx() , tx.c.

	Signed-off-by: Rami Rosen <ramirose@gmail.com>
	---
	(wireless-testing).

Thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
