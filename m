Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50110 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GOSou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 14:44:50 -0400
Received: by wwe5 with SMTP id 5so1552269wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 11:44:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310723867.4164.19.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-3-git-send-email-thomas@cozybit.com>
	<1310723867.4164.19.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jul 2011 11:44:49 -0700
Message-ID: <CAG6hwVO1hYQVFQ2YThkjDUuoP6ZN8MM_P0MUtnD_k258Z6zqnA@mail.gmail.com> (sfid-20110715_204454_090589_76713FE2)
Subject: Re: [PATCH 2/5] mac80211: correct mesh beacon head
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
>> Supported Rates and DS Parameter elements go in the beacon head. Add
>> these IEs when we initially construct the beacon.
>
> This breaks mesh_plink_frame_tx() afaict.

Yes, although DS parameters didn't belong there anyway. v2 will fix
this. Is there a better way in mac80211 to add these IEs than just
hardcoding them into the frame construction?

> johannes
>
>

Thanks,
Thomas
