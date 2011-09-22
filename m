Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47835 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1IVHhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:37:24 -0400
Received: by eya28 with SMTP id 28so1421505eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:37:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316606772.3940.30.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-4-git-send-email-arik@wizery.com> <1316606772.3940.30.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 10:37:08 +0300
Message-ID: <CA+XVXfcbrrR112Lf0oUz_Ok8NCo_M=nDNzOdRkdP3k+PrQZ0tg@mail.gmail.com> (sfid-20110922_093727_368024_11C1C0E0)
Subject: Re: [RFC 3/5] nl80211/mac80211: allow adding TDLS peers as stations
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 15:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>> When a TDLS peer STA is added it is marked with a new flag in both
>> nl80211 and in mac80211.
>
> I think it'd make some sense to allow only TDLS stations on a managed
> mode interface?

Yea i'll add the check.

Arik
