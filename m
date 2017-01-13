Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51006 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdAMNO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:14:29 -0500
Message-ID: <1484313263.8670.1.camel@sipsolutions.net> (sfid-20170113_141432_411766_F8115321)
Subject: Re: [PATCH] mac80211: fix documentation warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: linux-wireless@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Date: Fri, 13 Jan 2017 14:14:23 +0100
In-Reply-To: <4973EEB8-5F54-451E-B939-CDA94332CEF7@darmarit.de>
References: <20170113101201.7352-1-johannes@sipsolutions.net>
         <4973EEB8-5F54-451E-B939-CDA94332CEF7@darmarit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-13 at 13:43 +0100, Markus Heiser wrote:

> does it make live easier when we use in-line member comments:
> 
>  https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#in-
> line-member-documentation-comments
> 
> and place the entire list in a literalblock? 

Ah yes, I forgot about that. I should convert everything to that, but
that's probably better done separately.

johannes
