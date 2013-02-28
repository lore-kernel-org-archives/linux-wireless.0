Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3B1X4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 18:56:24 -0500
Message-ID: <1362095777.8330.15.camel@jlt4.sipsolutions.net> (sfid-20130301_005628_380667_9BBDCA3C)
Subject: Re: [PATCH 1/3] regulatory: allow VHT channels in world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, green@qca.qualcomm.com
Date: Fri, 01 Mar 2013 00:56:17 +0100
In-Reply-To: <CAB=NE6VonnZDQwat3PeCvnVJnuj-vKciK8WYCmbLzre+4zoLyw@mail.gmail.com> (sfid-20130301_003411_417728_43BAD6F7)
References: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net>
	 <1360797364-9430-2-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6VonnZDQwat3PeCvnVJnuj-vKciK8WYCmbLzre+4zoLyw@mail.gmail.com>
	 (sfid-20130301_003411_417728_43BAD6F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 15:33 -0800, Luis R. Rodriguez wrote:

> > For VHT, the wider bandwidths (up to 160 MHz) need
> > to be allowed. Since world roaming only covers the
> > case of connecting to an AP, it can be opened up
> > there, we will rely on the AP to know the local
> > regulations.

> This seems reasonable to me but in your patch you only allow 80, not
> 160, any reason for that?

160 doesn't fit here yet -- I think it should be enabled when/if those
DFS channels are added, I don't see a reason they're missing there.

johannes

