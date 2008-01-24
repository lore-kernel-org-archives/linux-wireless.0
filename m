Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37325 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYAXLRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 06:17:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: mac80211 does seem to have a netdev refcount bug
Date: Thu, 24 Jan 2008 12:15:59 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
References: <200801241148.25456.mb@bu3sch.de> <87ejc7a3dw.fsf@nokia.com>
In-Reply-To: <87ejc7a3dw.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801241215.59583.mb@bu3sch.de> (sfid-20080124_111726_021461_C91EAFF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 12:07:07 Kalle Valo wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> > There seems to be a netdevice refcounting (freeing) bug in mac80211.
> > I frequently see the "waiting for netdev to become free, refcount = 1"
> > message on rmmod. I don't remember the message text exactly, but I think you
> > know what I mean.
> 
> Most probably it's this one:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9778
> 
> There was a discussion on netdev about this. Not a mac80211 bug AFAIK.

Oh, yes. This might be possible. So let's see. It will soon be fixed then.

-- 
Greetings Michael.
