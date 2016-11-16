Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59580 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752755AbcKPMmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 07:42:04 -0500
Message-ID: <1479300119.4141.3.camel@sipsolutions.net> (sfid-20161116_134207_959280_C45CA664)
Subject: Re: [PATCH 0/8] iw: Add common chandef parser and new DFS related
 commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Date: Wed, 16 Nov 2016 13:41:59 +0100
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net> (sfid-20161107_155953_169276_BFE30AD3)
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
         (sfid-20161107_155953_169276_BFE30AD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-07 at 15:59 +0100, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@open-mesh.com>
> 
> Hi,
> 
> This patchset adds commands for doing a CAC and sending CSA.
> 
> Another change is that parsing of command line frequency and channel
> definitions is split out so that it can be shared between the
> different users.

That's nice :)

I've applied all except for patch 7 - I don't see any justification for
adding that - quite clearly iw will not listen to any radar detection
events, so even for testing/certification this doesn't seem useful
since then you'd want to check/prove that you *do* listen to those ...

johannes
