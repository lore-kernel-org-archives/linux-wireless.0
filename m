Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50139 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1IVHjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:39:19 -0400
Received: by eya28 with SMTP id 28so1421891eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316606815.3940.31.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-5-git-send-email-arik@wizery.com> <1316606815.3940.31.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 10:39:03 +0300
Message-ID: <CA+XVXfeNeLyiPxTLyUderJHsUAKukWGiAFZjJ4P5+siNou8pWg@mail.gmail.com> (sfid-20110922_093922_494320_438D87AA)
Subject: Re: [RFC 4/5] mac80211: add a HW flag for TDLS support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 15:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>> Allow TDLS operations and peers only in supporting hardware.
>
> In terms of patch ordering I think this should be part of patch 1 (and
> maybe patch 3 can be too), otherwise patch 2 adds some incomplete
> mac80211 stuff and even enables it ...

Sure.

Arik
