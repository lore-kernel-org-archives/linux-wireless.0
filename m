Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbcLGNpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 08:45:55 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8737i6syzq.fsf@kamboji.qca.qualcomm.com>
References: <8737i6syzq.fsf@kamboji.qca.qualcomm.com> <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk> <148059556349.31612.1087071308520573382.stgit@warthog.procyon.org.uk>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, minyard@acm.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH 23/39] Annotate hardware config module parameters in drivers/net/wireless/
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 07 Dec 2016 13:45:52 +0000
Message-ID: <25121.1481118352@warthog.procyon.org.uk> (sfid-20161207_144618_643095_0C1D5EBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> Via which tree are you planning to submit this, should I take it to
> wireless-drivers or will someone else handle it? I didn't get the cover
> letter so I have no idea.

I'll see if I can get patch 1 (which defines the macros) in a window prior to
the others - or maybe I can get Linus to apply all of these together.

David
