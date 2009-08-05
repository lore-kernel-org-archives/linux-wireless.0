Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39352 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934703AbZHERBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 13:01:03 -0400
Date: Wed, 5 Aug 2009 12:50:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: xxiao <austinxxh-ath9k@yahoo.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Subject: Re: Status of 802.11s in wireless-testing?
Message-ID: <20090805165021.GA20338@tuxdriver.com>
References: <2f1373ed0908042145pc83adc5qd968e3bf8d0ce3c7@mail.gmail.com> <175701.5780.qm@web55308.mail.re4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <175701.5780.qm@web55308.mail.re4.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2009 at 09:08:54AM -0700, xxiao wrote:
> I didn't see patches from open80211s project for a while, which
> means it will break as the rest mac80211/drivers are evolving quickly.

You may be right, but it _should_not_ mean that -- at least not
necessarily.  Yes, there will be accidental breakage from time to time.
But developers ought to keep mesh in mind when making changes and
they should be "on the hook" to fix whatever breaks.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
