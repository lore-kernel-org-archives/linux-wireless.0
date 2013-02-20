Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab3BTUBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:01:34 -0500
Message-ID: <1361390479.8579.7.camel@jlt4.sipsolutions.net> (sfid-20130220_210139_844479_DDA3DA31)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 20 Feb 2013 21:01:19 +0100
In-Reply-To: <CAG6hwVNFffZ=gPi408WEAVd42yytxXe5zD_Y54G=hqbtwFcALw@mail.gmail.com> (sfid-20130220_192203_272390_9F0B2A60)
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
	 <1361197194.8555.17.camel@jlt4.sipsolutions.net>
	 <CAGRGNgWLHTV2T9WFAGtB8Wz4=zNcrCUkHVFJX5Q=kdbFLTSKOQ@mail.gmail.com>
	 <1361348702.8629.0.camel@jlt4.sipsolutions.net>
	 <CAG6hwVNFffZ=gPi408WEAVd42yytxXe5zD_Y54G=hqbtwFcALw@mail.gmail.com>
	 (sfid-20130220_192203_272390_9F0B2A60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 10:21 -0800, Thomas Pedersen wrote:

> Yes it's nice we can leave out mesh when not useful, will put this in
> the PATCH. Do you think it will be alright if I go ahead and add the
> 'select' to all supported drivers in the same patch?

Fine with me, I doubt you'd have the driver maintainers complain :)

johannes

