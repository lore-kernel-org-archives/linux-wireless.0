Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55010 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab2KMUxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:53:42 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so4712010qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 12:53:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352839474.9466.33.camel@jlt4.sipsolutions.net>
References: <1352832387-21162-1-git-send-email-thomas@cozybit.com> <1352839474.9466.33.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 13 Nov 2012 12:53:21 -0800
Message-ID: <CAG6hwVPhzSyFPHj8p37Si8dHpFBH6Q98RNhuWnRKY7kmk24crA@mail.gmail.com> (sfid-20121113_215345_636752_0D6AFF34)
Subject: Re: [PATCH v2] mac80211: support RX_FLAG_MACTIME_END
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 13, 2012 at 12:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-11-13 at 10:46 -0800, Thomas Pedersen wrote:
>> Allow drivers to indicate their mactime is at RX completion and adjust
>> for this in mac80211. Also rename the existing RX_FLAG_MACTIME_MPDU to
>> RX_FLAG_MACTIME_START to clarify its intent. Based on similar code by
>> Johannes Berg.
>
> Applied, but I had to fix up the patch to apply on mac80211-next, and
> even had to make it compile by adjusting the Atheros drivers ...

Rats. It applied on wireless-testing. In the future, submitted
mac80211 patches should be rebased onto mac80211-next?

Thomas
