Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36975 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab1HJVbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 17:31:18 -0400
Received: by wwf5 with SMTP id 5so1404203wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 14:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312984078.4325.5.camel@jlt3.sipsolutions.net>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	<1312933511-9486-9-git-send-email-thomas@cozybit.com>
	<1312984078.4325.5.camel@jlt3.sipsolutions.net>
Date: Wed, 10 Aug 2011 14:31:17 -0700
Message-ID: <CAG6hwVNFUyt7VBEiaNpCoGFmt4eMbvexKA0pUtGi3sj3mwHgZQ@mail.gmail.com> (sfid-20110810_233127_169213_83AFCE65)
Subject: Re: [PATCH 8/8] {nl,cfg,mac}80211: let userspace make meshif mesh gate
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 6:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>>
>> Allow userspace to set NL80211_MESHCONF_GATE_ANNOUNCEMENTS attribute,
>> which will advertise this mesh node as being a mesh gate.
>> NL80211_HWMP_ROOTMODE must be set or this will do nothing.
>
> IMHO it should be rejected instead of doing nothing.
>
Maybe the "right thing" to do is not require the user to know anything
about the limitations of our implementation, and instead just enable
root mode as needed?
> johannes
>
>
