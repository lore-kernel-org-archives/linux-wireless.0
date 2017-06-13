Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:51577 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752326AbdFMN2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 09:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <1497342000.6068.3.camel@sipsolutions.net>
References: <20170610025912.6499-1-Jason@zx2c4.com> <20170610025912.6499-7-Jason@zx2c4.com>
 <1497342000.6068.3.camel@sipsolutions.net>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 13 Jun 2017 15:28:15 +0200
Message-ID: <CAHmME9pJEwPvpNMGc9KCH15BNO8qRNCEw2Mh4nUjVK0c2X30kA@mail.gmail.com> (sfid-20170613_152851_590472_B1E8255A)
Subject: Re: [PATCH 6/6] mac80211/wpa: use constant time memory comparison for MACs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 13, 2017 at 10:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I'm not really sure that this is actually true, since you don't get
> much feedback on your frame that's dropped, especially if you're
> attacking from remote. Basically, I don't see how you can observe the
> timing of this operation?

There have been practical attacks published before that relied on
jitter coming from simultaneous operations.

> Anyway, applied.

Great, thanks.
