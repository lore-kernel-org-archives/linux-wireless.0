Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37610 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdBWN3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 08:29:09 -0500
Received: by mail-it0-f54.google.com with SMTP id 203so15862461ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 05:29:08 -0800 (PST)
Date: Thu, 23 Feb 2017 07:01:42 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ryan Mounce <ryan@mounce.com.au>,
        wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
Message-ID: <20170223130142.GA90803@ubuntu-hedt> (sfid-20170223_142912_969339_69E6BE8A)
References: <20170218063515.16071-1-ryan@mounce.com.au>
 <20170222213057.GA33925@ubuntu-hedt>
 <CAN+fvRb8R_3QyrnFFp0gd8PCcFXwbitNyh8K=ONqbmsGTrBsHQ@mail.gmail.com>
 <1487829525.1956.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487829525.1956.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2017 at 06:58:45AM +0100, Johannes Berg wrote:
> 
> > The frequency ranges have been "rounded down" to conform with the
> > apparent convention of only including ranges used by standard 802.11
> > channels, rather than using the actual frequency ranges as has been
> > done for some countries (and most 60GHz rules). My preference is the
> > latter so that there is a clear correlation between the regdb and
> > relevant documentation, and so that the regdb may become useful
> > beyond 802.11. With your blessing as maintainer I will also make this
> > change to the patch.
> 
> I think that's just an artifact of the original database source and
> would also prefer the documented ranges to be used.

Yes, I prefer the documented ranges as well.

Thanks,
Seth
