Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2ISTcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 15:32:23 -0400
Received: by weyx8 with SMTP id x8so790291wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 12:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 19 Sep 2012 22:32:06 +0300
Message-ID: <CA+XVXfcxHENu1HzY+-WkyMr6g+3P2wSyj7BhDsfKgZoB7fZHRg@mail.gmail.com> (sfid-20120919_213226_679561_746087FF)
Subject: Re: [PATCH 0/3] mac80211: avoid useless delBA frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2012 at 1:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> There are a few situations where it's completely pointless
> to send delBA action frames, so let's remove them.

Maybe it's a good opportunity to also fix ieee80211_reconfig? I
remember you mentioned some FW/HW issue there, perhaps this was solved
in the meantime. Otherwise we can add a HW flag for that I guess.

Arik
