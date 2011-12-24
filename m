Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37937 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1LXWvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Dec 2011 17:51:04 -0500
Received: by iaeh11 with SMTP id h11so17043874iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Dec 2011 14:51:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324740691.6872.1.camel@jlt3.sipsolutions.net>
References: <1324643075-29385-1-git-send-email-eliad@wizery.com>
	<1324740691.6872.1.camel@jlt3.sipsolutions.net>
Date: Sun, 25 Dec 2011 00:51:02 +0200
Message-ID: <CAB3XZEdaaXmyg246GFcTH1Y+4R5OxHBeufYyLhTW-ftbS7Uzbw@mail.gmail.com> (sfid-20111224_235126_049288_3A8A0296)
Subject: Re: [PATCH 0/3] notify driver about changes in station state
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 24, 2011 at 5:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-12-23 at 14:24 +0200, Eliad Peller wrote:
>> This patchset is a sequel for Johannes' "station management rework"
>> patchset. It adds a new sta_state callback, so low-level driver
>> will be able to register for station state changes.
>
> The only comment I have here is that I think structurally it would be
> preferable to also call this when a station is uploaded, so the driver
> doesn't have to check the state it's uploaded in. Or maybe not?
>
yes. it sounds like a better approach.
i'll give it a spin (but it won't happen before the end of this week).

Eliad.
