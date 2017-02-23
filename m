Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59710 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751391AbdBWGXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 01:23:44 -0500
Message-ID: <1487829525.1956.2.camel@sipsolutions.net> (sfid-20170223_072352_928025_A7C0E44A)
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Ryan Mounce <ryan@mounce.com.au>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 23 Feb 2017 06:58:45 +0100
In-Reply-To: <CAN+fvRb8R_3QyrnFFp0gd8PCcFXwbitNyh8K=ONqbmsGTrBsHQ@mail.gmail.com> (sfid-20170223_001058_739420_4AD8E69A)
References: <20170218063515.16071-1-ryan@mounce.com.au>
         <20170222213057.GA33925@ubuntu-hedt>
         <CAN+fvRb8R_3QyrnFFp0gd8PCcFXwbitNyh8K=ONqbmsGTrBsHQ@mail.gmail.com>
         (sfid-20170223_001058_739420_4AD8E69A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The frequency ranges have been "rounded down" to conform with the
> apparent convention of only including ranges used by standard 802.11
> channels, rather than using the actual frequency ranges as has been
> done for some countries (and most 60GHz rules). My preference is the
> latter so that there is a clear correlation between the regdb and
> relevant documentation, and so that the regdb may become useful
> beyond 802.11. With your blessing as maintainer I will also make this
> change to the patch.

I think that's just an artifact of the original database source and
would also prefer the documented ranges to be used.

johannes
