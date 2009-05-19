Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57320 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZESRpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 13:45:11 -0400
Date: Tue, 19 May 2009 13:42:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: split out and decrease probe wait time
Message-ID: <20090519174137.GE2691@tuxdriver.com>
References: <1242151393.11924.3.camel@johannes.local> <1242151886.11924.5.camel@johannes.local> <1242754648.4797.46.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242754648.4797.46.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 07:37:28PM +0200, Johannes Berg wrote:
> You know ... somehow I managed to send out v2 with a wrong interval.
> 
> This was supposed to be / 5 not / 20, should I send a separate patch or
> would you roll this into the original? The commit log says 200ms, but
> the code uses 50ms which is far too short.

Ok, I'll roll this up...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
