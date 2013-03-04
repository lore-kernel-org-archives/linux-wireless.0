Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3CDTw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:52:26 -0500
Message-ID: <1362426735.21028.39.camel@jlt4.sipsolutions.net> (sfid-20130304_205233_450157_8A65F7D4)
Subject: Re: [PATCH 1/3] regulatory: allow VHT channels in world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, green@qca.qualcomm.com
Date: Mon, 04 Mar 2013 20:52:15 +0100
In-Reply-To: <CAB=NE6XWbOXUb8Ac8na-5iRRCaGLQgg5gWBKd7Hnuim7-rFAoA@mail.gmail.com> (sfid-20130304_202018_308869_12E2D603)
References: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net>
	 <1360797364-9430-2-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6VonnZDQwat3PeCvnVJnuj-vKciK8WYCmbLzre+4zoLyw@mail.gmail.com>
	 <1362095777.8330.15.camel@jlt4.sipsolutions.net>
	 <CAB=NE6XWbOXUb8Ac8na-5iRRCaGLQgg5gWBKd7Hnuim7-rFAoA@mail.gmail.com>
	 (sfid-20130304_202018_308869_12E2D603)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 11:19 -0800, Luis R. Rodriguez wrote:
> On Thu, Feb 28, 2013 at 3:56 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2013-02-28 at 15:33 -0800, Luis R. Rodriguez wrote:
> >
> >> > For VHT, the wider bandwidths (up to 160 MHz) need
> >> > to be allowed. Since world roaming only covers the
> >> > case of connecting to an AP, it can be opened up
> >> > there, we will rely on the AP to know the local
> >> > regulations.
> >
> >> This seems reasonable to me but in your patch you only allow 80, not
> >> 160, any reason for that?
> >
> > 160 doesn't fit here yet -- I think it should be enabled when/if those
> > DFS channels are added, I don't see a reason they're missing there.
> 
> True. OK I checked internally and enabling VHT80 is reasonable, as for
> the DFS stuff you mentioned, you are right as well, but that should be
> done through a separate patch. The only thing to consider there is
> scan time increases considerably but seems like a reasonable
> compromise. I'm surprised no one has had issues before with this.
> 
> Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Ok, applied the patch then. I'll send a patch for those DFS channels
momentarily, care to take of db.txt?

johannes

