Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:22669 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYA1QXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:23:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3075458wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 08:23:53 -0800 (PST)
Message-ID: <1ba2fa240801280823t7a591564pa9129d4799690caf@mail.gmail.com> (sfid-20080128_162358_403983_13890F39)
Date: Mon, 28 Jan 2008 18:23:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and driver conversion
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080128151032.GB5835@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080124183837.577631000@sipsolutions.net>
	 <20080124184357.839387000@sipsolutions.net>
	 <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com>
	 <20080128151032.GB5835@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 28, 2008 5:10 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Jan 28, 2008 at 02:49:06AM +0200, Tomas Winkler wrote:
> > On Jan 24, 2008 8:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > This patch creates new cfg80211 wiphy API for channel and bitrate
> > > registration and converts mac80211 and drivers to the new API. The
>
> <snip>
>
> > > I do expect there to be bugs in this, especially wrt. transmit
> > > power handling where I'm basically clueless about how it should work.
> >
> > True, total havoc
> >
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > > Changes:
> > > v1..v3: <untracked>
> > > v4:     fix bugs in iwl4965
> >
> > Also inserting few, actually drawing it unusable. You are lucky we
> > like you here :)
> > The question is how we handle this?. Do you want  to resubmit this
> > huge patch or we fix it somehow over it...
>
> I think I'm going to hold this back from Dave for 2.6.25.  It might
> be better if we can fix any known problems with this patch before
> re-merging it for pre-2.6.26 development.
>

So will you branch it publicly in wireless-2.6 or  we do it on mailing
list?  I have some patches for iwl4965 to make HT compile again but
after Pandora's box has opened so I stopped to try? I will send them
out.
What is the window left for 2.6.25? I'm just worried about cfg80211
general progress.
Thanks
Tomas

> John
> --
> John W. Linville
> linville@tuxdriver.com
>
