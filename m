Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:62342 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbXIGRpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 13:45:52 -0400
Received: by mu-out-0910.google.com with SMTP id i10so830481mue
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2007 10:45:50 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter configuration
Date: Fri, 7 Sep 2007 19:56:25 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
References: <20070905234209.108005000@sipsolutions.net> <200709061905.54102.IvDoorn@gmail.com> <1189171384.28781.129.camel@johannes.berg>
In-Reply-To: <1189171384.28781.129.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709071956.26009.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2007, Johannes Berg wrote:
> On Thu, 2007-09-06 at 19:05 +0200, Ivo van Doorn wrote:
> 
> > rt2x00 changes look good to me,
> > it will probably take me some time to find time
> > to make the full correct patch to fix rt2x00 but
> > I'll do my best to do it as soon as possible.
> 
> Well, this patch isn't fully discussed and obviously not applied yet,
> however, if it gets to be applied I think I'd rather have the rt*
> drivers not compile (without my patch) than BUG_ON.

Agreed.
In any case rt2x00 shouldn't hold this patch back.

Ivo

