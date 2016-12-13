Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53028 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932529AbcLMWaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 17:30:02 -0500
Message-ID: <1481668194.22319.0.camel@sipsolutions.net> (sfid-20161213_233010_819467_2D076F17)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2016 23:29:54 +0100
In-Reply-To: <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com> (sfid-20161213_210929_370410_C9505C9C)
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
         <1481645962.20412.41.camel@sipsolutions.net>
         <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com>
         (sfid-20161213_210929_370410_C9505C9C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-12-13 at 21:09 +0100, Arend Van Spriel wrote:
> 
> > There's a bit of a weird hard-coded restriction to 16 channels too,
> > that's due to the bucket map?
> 
> Uhm. Is there? I will check, but if you can give me a pointer where
> to look it is appreciated.

Just look for "< 16" or "<= 16" or so in the patch. I do think that's
because the channel map is a u16 though, not sure we'd want to change
that.

johannes
