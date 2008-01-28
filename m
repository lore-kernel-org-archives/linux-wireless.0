Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4280 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYA1PdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 10:33:22 -0500
Date: Mon, 28 Jan 2008 10:10:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
Message-ID: <20080128151032.GB5835@tuxdriver.com> (sfid-20080128_153325_388388_FCF6921E)
References: <20080124183837.577631000@sipsolutions.net> <20080124184357.839387000@sipsolutions.net> <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2008 at 02:49:06AM +0200, Tomas Winkler wrote:
> On Jan 24, 2008 8:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > This patch creates new cfg80211 wiphy API for channel and bitrate
> > registration and converts mac80211 and drivers to the new API. The

<snip>

> > I do expect there to be bugs in this, especially wrt. transmit
> > power handling where I'm basically clueless about how it should work.
> 
> True, total havoc
> 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Changes:
> > v1..v3: <untracked>
> > v4:     fix bugs in iwl4965
> 
> Also inserting few, actually drawing it unusable. You are lucky we
> like you here :)
> The question is how we handle this?. Do you want  to resubmit this
> huge patch or we fix it somehow over it...

I think I'm going to hold this back from Dave for 2.6.25.  It might
be better if we can fix any known problems with this patch before
re-merging it for pre-2.6.26 development.

John
-- 
John W. Linville
linville@tuxdriver.com
