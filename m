Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:52543 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYEMO6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 10:58:53 -0400
Received: by ug-out-1314.google.com with SMTP id h2so911259ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 07:58:51 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: BUG: scheduling while atomic: rt73usb
Date: Tue, 13 May 2008 17:10:13 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian =?iso-8859-1?q?Sch=E4fer?= <schaefer@in.tum.de>,
	linux-wireless@vger.kernel.org
References: <482952C3.9020209@in.tum.de> <200805131310.19980.IvDoorn@gmail.com> <20080513142826.GC6273@tuxdriver.com>
In-Reply-To: <20080513142826.GC6273@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805131710.13417.IvDoorn@gmail.com> (sfid-20080513_165855_967583_E1F02F56)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008, John W. Linville wrote:
> On Tue, May 13, 2008 at 01:10:19PM +0200, Ivo van Doorn wrote:
> > On Tuesday 13 May 2008, Johannes Berg wrote:
> > > 
> > > >   [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
> > > >   [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
> > > >   [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
> > > 
> > > If I read this correctly, it was recently fixed (but not committed yet
> > > afaict)
> > 
> > Yes, the fix was send as part of a pull request from rt2x00.git,
> > and I've requested it to be merged for 2.6.26 as well.
> 
> Hmmmm...is that "mac80211: Add RTNL version of
> ieee80211_iterate_active_interfaces"?  I didn't see any indication
> that one was for 2.6.26.  If it is, I'll get it out with the next
> round of fixes.

Yep, that is the one.
I marked it as 2.6.26 material when I send it as separate patch,
but didn't in the pull request of last saturday.
But the subject didn't contain any hint about it being a bugfix,
so it is easy to overlook. ;)

Ivo
