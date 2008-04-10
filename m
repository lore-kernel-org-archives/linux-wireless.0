Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:30248 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbYDJSLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 14:11:50 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1365356ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2008 11:11:27 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 ifup & ifdown
Date: Thu, 10 Apr 2008 20:11:56 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804100017.23359.IvDoorn@gmail.com> <1207839011.19080.11.camel@johannes.berg>
In-Reply-To: <1207839011.19080.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804102011.57014.IvDoorn@gmail.com> (sfid-20080410_191154_922286_558501D2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 April 2008, Johannes Berg wrote:
> 
> > I think I recently saw some discussion about mac80211 having a bug
> > when the interface was brought down and back up again which would
> > leave mac80211 & driver in a state from which it could no longer be
> > able to associate again.
> > 
> > I can't find the particular email again, but was this issue indeed a bug
> > with mac80211? And if so, is that bug present in 2.6.25 or only in
> > wireless-testing?
> 
> The only thing I can remember is that it didn't used to automatically
> re-associate which should be in now.

Ah ok. Thanks for the clarification.
Hopefully that solves one of the rt2x00 bugs. :)

Ivo
