Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54547 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1JNRTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 13:19:37 -0400
Received: by qyk27 with SMTP id 27so83134qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 10:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E985579.9010401@gmail.com>
References: <1317543352-29019-1-git-send-email-eliad@wizery.com>
	<1318433496.3933.44.camel@jlt3.sipsolutions.net>
	<4E985579.9010401@gmail.com>
Date: Fri, 14 Oct 2011 13:19:36 -0400
Message-ID: <CAEKwDSA0UjuDvq-=YfO_CJaQGmOPVGMp1AqNx1Fkrv6crf4oAg@mail.gmail.com> (sfid-20111014_191940_251238_27418498)
Subject: Re: [PATCH] patch on comment
From: Bob Copeland <me@bobcopeland.com>
To: Loiseau Lucien <loiseau.lucien@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 14, 2011 at 11:30 AM, Loiseau Lucien
<loiseau.lucien@gmail.com> wrote:
> Digging into the source code, i noticed that the documentation tells that
> the tx function from ieee80211_ops should return NETDEV_TX_OK while the tx
> function is now a void function.

This is good, but as presented, you've left the job for others to make
the patch suitable for applying to the kernel.  Please see
Documentation/SubmittingPatches for more info.  For example, a better
email / commit message might be:

[PATCH] mac80211: remove reference to NETDEV_TX_OK

The kerneldoc states that ieee80211_ops.tx must return NETDEV_TX_OK,
but tx is now a void function.  Remove the stale comment.

Signed-off-by: <your-s-o-b-here>

---
[patch goes here]

It's almost the same as what you wrote, but there is a Signed-off-by,
and the subject and description are fit for the long term kernel
history.

If you perform these few extra steps when submitting, John can just
queue your patch directly from his inbox, and you get to keep all the
credit.  If you make the maintainer's job hard, he might drop it on
the floor until someone else does the work.

-- 
Bob Copeland %% www.bobcopeland.com
