Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56465 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab1BIOp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:45:27 -0500
Date: Wed, 9 Feb 2011 09:34:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] DFS userspace handler
Message-ID: <20110209143422.GB2494@tuxdriver.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 01:01:40PM +0100, Zefir Kurtisi wrote:
> Hello DFS folks,
> 
> this is a patch series to prove the concept of DFS handling done in userspace.
> 
> It moves the radar pattern detector introduced in [1] and documented in [2] 
> from mac80211 up to hostapd.

I'll let the smart people comment on the workability of this. :-)
But from a kernel interface standpoint it seems reasonable to me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
