Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44140 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAWCSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 21:18:21 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so5046621wgg.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 18:18:20 -0800 (PST)
MIME-Version: 1.0
From: Avery Pennarun <apenwarr@gmail.com>
Date: Thu, 22 Jan 2015 21:17:57 -0500
Message-ID: <CAHqTa-0BYeQtwYBUAYwjx-zhitUq0q=m_-fMWbx4KM7TjeqhOQ@mail.gmail.com> (sfid-20150123_031824_948243_310025AD)
Subject: Re: REMINDER: wireless workshop in Ottawa
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> wrote:
> I am afraid I will be "committing a netdev crime" [1] because I will
> not attend. Still there is one topic that would be interesting for
> this conf/workshop. Recent experiences with 11ac devices has shown us
> that the congestion control mechanisms in the networking subsystem are
> not optimal for wireless in general which becomes even more visible
> with 11ac (or it is just our devices :-p ). If there are people in the
> community working in this area it would be great to collaborate on it.
> Let me know. I know Dave Taht is the usual suspect to talk to about
> this so Cc'ed him explicitly.

I'm planning to be there, and I work with Dave Taht regularly about
such things.  I would love to have a discussion about these issues
with whoever is willing to listen :)

Also, you have not experienced congestion control problems until
you've tried to get TCP to do a gigabit per second with 30+
milliseconds of latency on a slightly lossy network.

Have fun,

Avery
