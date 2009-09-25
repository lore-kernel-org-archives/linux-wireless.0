Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48654 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZIYSFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 14:05:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matthew Ryan <rudicus@gmail.com>
Subject: Re: Porting AR6K to use cfg80211
Date: Fri, 25 Sep 2009 20:05:22 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20090925T193922-290@post.gmane.org>
In-Reply-To: <loom.20090925T193922-290@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909252005.23746.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
> I was curious if I could get a few expert opinions on if its possible to port
> this driver to use mac80211, and how difficult/ what pitfalls there may be.

The device is fullmac, so it does not require mac80211.
I guess however, ar6k can be ported to use cfg80211.

-- 
Greetings, Michael.
