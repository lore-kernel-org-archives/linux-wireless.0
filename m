Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:48704 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752718AbcJKVjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 17:39:13 -0400
Date: Tue, 11 Oct 2016 15:39:11 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] docs-rst: sphinxify 802.11 documentation
Message-ID: <20161011153911.6a0f778c@lwn.net> (sfid-20161011_233916_990509_BED5D3A8)
In-Reply-To: <1476192636.4118.8.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
        <20161011072119.7ad4e3a3@lwn.net>
        <1476192636.4118.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Oct 2016 15:30:36 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Maybe I can just take the relevant header file change through my tree?
> 
> It would cause the following warning to appear in your tree:
> 
> include/net/cfg80211.h:3093: WARNING: Definition list ends without a blank line; unexpected unindent.
> include/net/cfg80211.h:3095: ERROR: Unexpected indentation.
> include/net/cfg80211.h:3099: WARNING: Block quote ends without a blank line; unexpected unindent.
> include/net/cfg80211.h:3107: WARNING: Definition list ends without a blank line; unexpected unindent.
> include/net/cfg80211.h:3109: ERROR: Unexpected indentation.
> include/net/cfg80211.h:3113: WARNING: Block quote ends without a blank line; unexpected unindent.
> include/net/cfg80211.h:3123: ERROR: Unexpected indentation.
> include/net/cfg80211.h:3124: WARNING: Definition list ends without a blank line; unexpected unindent.
> include/net/cfg80211.h:3126: ERROR: Unexpected indentation.
> include/net/cfg80211.h:3130: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> for the time being - perhaps you can live with that, until my changes
> also propagate through to the tree?

I could live with that, I guess, though I'm not thrilled with the idea.

As an alternative, one or the other of us could just send it up in the
next couple of days and be done with it.  I'd say the chances of
regressions are pretty small...:)  If you want to do that, feel free to
add my ack.  If you'd rather I sent it, just say the word.

jon
