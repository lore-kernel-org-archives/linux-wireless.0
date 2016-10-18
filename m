Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55602 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbcJRLnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 07:43:45 -0400
Message-ID: <1476791021.6425.25.camel@sipsolutions.net> (sfid-20161018_134348_979504_B8B26074)
Subject: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Tue, 18 Oct 2016 13:43:41 +0200
In-Reply-To: <1476194038.4118.11.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-11 at 15:53 +0200, Johannes Berg wrote:
> > 
> > 
> > Related question: I have some sequence diagrams, and just found the
> > seqdiag sphinx plugin. How should we manage adding extensions? Or
> > would you prefer not to add any at all?
> 
> Example here:
> https://johannes.sipsolutions.net/files/80211/mac80211.html#connection-flow

Coming back to this - sadly, it appears that this software (blockdiag,
seqdiag) is completely unmaintained, with open pull requests dating
back to 2012 and the last commit dating back to 2015-08-22.

I'd want/need feature improvements in it too, but if I can't feed those
back to upstream (since it appears dead), there's little point.

Perhaps we can ship plugins for this as part of the kernel sources?
Shouldn't be too difficult to reimplement something like this, after
all.

johannes
