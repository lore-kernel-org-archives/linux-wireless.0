Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57187 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbbF2H4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 03:56:35 -0400
Message-ID: <1435564593.2156.5.camel@sipsolutions.net> (sfid-20150629_095638_779931_13C274A8)
Subject: Re: [PATCH] mac80211: remove compilation warning on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 29 Jun 2015 09:56:33 +0200
In-Reply-To: <CAEFj987fG9NrxWUfqtf3UVD8uWzAB-TeYAJvTDDoyH0JxUHKhA@mail.gmail.com> (sfid-20150629_094111_166190_7B4A97CF)
References: <1435549847-18680-1-git-send-email-yeohchunyeow@gmail.com>
	 <1435562850.2156.4.camel@sipsolutions.net>
	 <CAEFj987fG9NrxWUfqtf3UVD8uWzAB-TeYAJvTDDoyH0JxUHKhA@mail.gmail.com>
	 (sfid-20150629_094111_166190_7B4A97CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-29 at 15:41 +0800, Yeoh Chun-Yeow wrote:
> On Mon, Jun 29, 2015 at 3:27 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2015-06-29 at 11:50 +0800, Chun-Yeow Yeoh wrote:
> > > Remove the warning on the following:
> > > mesh_hwmp.c: warning: ‘target_metric’ may be used
> > > uninitialized in this function [-Wmaybe-uninitialized]
> > > 
> > I don't see any such warning, and would prefer not to have a 
> > blanket
> > initialization that might in the future suppress a valid warning.
> > 
> 
> Ok, noted.
> 
> FYI, I have compiled backports-20150626 and observed this warning
> 

It probably depends on the compiler version?

johannes
