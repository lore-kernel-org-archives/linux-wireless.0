Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3728 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYA1SdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 13:33:11 -0500
Date: Mon, 28 Jan 2008 13:23:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
Message-ID: <20080128182347.GG5835@tuxdriver.com> (sfid-20080128_183316_886637_BC8502DB)
References: <20080124183837.577631000@sipsolutions.net> <20080124184357.839387000@sipsolutions.net> <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com> <20080128151032.GB5835@tuxdriver.com> <1ba2fa240801280823t7a591564pa9129d4799690caf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240801280823t7a591564pa9129d4799690caf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2008 at 06:23:53PM +0200, Tomas Winkler wrote:
> On Jan 28, 2008 5:10 PM, John W. Linville <linville@tuxdriver.com> wrote:

> > I think I'm going to hold this back from Dave for 2.6.25.  It might
> > be better if we can fix any known problems with this patch before
> > re-merging it for pre-2.6.26 development.
> >
> 
> So will you branch it publicly in wireless-2.6 or  we do it on mailing
> list?  I have some patches for iwl4965 to make HT compile again but
> after Pandora's box has opened so I stopped to try? I will send them
> out.
> What is the window left for 2.6.25? I'm just worried about cfg80211
> general progress.

The development window for 2.6.25 is closed.

The API change will remaind in wireless-2.6 throughout the 2.6.26
development cycle.  Please send any fixes for breakage caused by this
patch ASAP.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
