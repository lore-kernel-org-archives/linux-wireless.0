Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40913 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbeDSJUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 05:20:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
In-Reply-To: <20180219170224.14816-1-toke@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
Date: Thu, 19 Apr 2018 11:20:18 +0200
Message-ID: <8736zr1rjh.fsf@toke.dk> (sfid-20180419_112023_143492_C28A4BC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> This series adds TXQ parameters and statistics that were previously only
> available through debugfs to the nl80211 userspace interface and the
> cfg80211 kernel interface. Patches for iw to print the statistics and
> change the settings are included.

So this patch set is now three months old. Any chance of actually
getting it, you know, merged? Or is there something more I need to do? :)

-Toke
