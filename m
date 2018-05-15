Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46559 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752452AbeEOIvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 04:51:40 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Sriram R <srirrama@codeaurora.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: Re: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx statistics
In-Reply-To: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
Date: Tue, 15 May 2018 10:51:38 +0200
Message-ID: <87y3gl1eud.fsf@toke.dk> (sfid-20180515_105144_258553_75E0A34C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sriram R <srirrama@codeaurora.org> writes:

> This patchset adds support for the collection and propagating of
> per-rate, per-station rx statistics when enabled by a userspace
> application.

Why not report TX rate statistics as well, when it is available?
Minstrel already collects this, and it is available via debugfs (the
rc_stats file); so if you're adding a netlink API, it seems odd to not
include TX stats as well...

-Toke
