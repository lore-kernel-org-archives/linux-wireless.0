Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0JEJYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:24:14 -0400
Date: Tue, 5 Oct 2010 11:25:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/6] mac80211: perform scan cancel in hw reset work
Message-ID: <20101005092526.GA18833@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
 <1285949495.3739.39.camel@jlt3.sipsolutions.net>
 <AANLkTintS4GU5-uYjMyY5bA1RaJL5cby1aKEpmZhSBkN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTintS4GU5-uYjMyY5bA1RaJL5cby1aKEpmZhSBkN@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 01, 2010 at 10:20:08AM -0700, Luis R. Rodriguez wrote:
> > This one's obvious -- the other ones I need a bit of time to review, and
> > it's practically weekend here now. I'll try to get to it ASAP.
> 
> I'm going to suck this into linux-next-pending/ on compat-wireless for
> today's release as it may fix a deadlock with carl9170.

John,

Since this patch is obvious and fix real bugs please apply it. Other
patches in the series need more work, I will repost them without this
one.

Stanislaw
