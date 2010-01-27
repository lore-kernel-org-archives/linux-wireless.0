Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33169 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0A0Qae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 11:30:34 -0500
Date: Wed, 27 Jan 2010 11:17:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
Message-ID: <20100127161725.GC2962@tuxdriver.com>
References: <941694.35079.qm@web51401.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <941694.35079.qm@web51401.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 07:51:06AM -0800, Joerg Pommnitz wrote:
> John,
> thanks for the quick response. The patch works fine for me. Feel free to add a
> 
> Tested-by: "Joerg Pommnitz" <pommnitz@yahoo.com>

Joerg,

I still haven't had time for a reboot. :-(  I wonder if you tested
to make sure that using "fixed" or just a rate by itself still works
properly too?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
