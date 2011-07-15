Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1GOVAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 17:00:55 -0400
Subject: Re: [PATCH 2/5] mac80211: correct mesh beacon head
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVO1hYQVFQ2YThkjDUuoP6ZN8MM_P0MUtnD_k258Z6zqnA@mail.gmail.com> (sfid-20110715_204511_138077_B4574EDE)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-3-git-send-email-thomas@cozybit.com>
	 <1310723867.4164.19.camel@jlt3.sipsolutions.net>
	 <CAG6hwVO1hYQVFQ2YThkjDUuoP6ZN8MM_P0MUtnD_k258Z6zqnA@mail.gmail.com>
	 (sfid-20110715_204511_138077_B4574EDE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 23:00:54 +0200
Message-ID: <1310763654.4164.30.camel@jlt3.sipsolutions.net> (sfid-20110715_230058_664834_0D950E69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-07-15 at 11:44 -0700, Thomas Pedersen wrote:
> On Fri, Jul 15, 2011 at 2:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
> >> Supported Rates and DS Parameter elements go in the beacon head. Add
> >> these IEs when we initially construct the beacon.
> >
> > This breaks mesh_plink_frame_tx() afaict.
> 
> Yes, although DS parameters didn't belong there anyway. v2 will fix
> this. Is there a better way in mac80211 to add these IEs than just
> hardcoding them into the frame construction?

Not sure what you mean, but I guess not.

johannes

