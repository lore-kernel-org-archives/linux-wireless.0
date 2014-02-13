Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61490 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBMKI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 05:08:26 -0500
Received: by mail-vc0-f177.google.com with SMTP id if11so7867982vcb.22
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 02:08:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392285810.4150.5.camel@jlt4.sipsolutions.net>
References: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
 <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com>
 <1392282362.4150.4.camel@jlt4.sipsolutions.net> <CA+XVXfc+chWOPuJ5A61+yrJDbUTqb+8-kWZG6ZG4SOONMJJi8g@mail.gmail.com>
 <1392285810.4150.5.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 13 Feb 2014 12:08:06 +0200
Message-ID: <CA+XVXffG-X_fdapYZ2n1fJtG61CgSQYkfQ4dr4aPK2vC-VCLeQ@mail.gmail.com> (sfid-20140213_110836_224920_FBE6A529)
Subject: Re: [PATCH] mac80211: add NAPI support back
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-13 at 12:00 +0200, Arik Nemtsov wrote:
>
>> It's fine. But I guess it's nicer to add a small ieee80211 wrapper for
>> it that also clears local->napi? not sure.
>
> Well if the whole thing is going down there's little point in that.

Sure.

Arik
