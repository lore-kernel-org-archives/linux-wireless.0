Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41969 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab0LPTMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 14:12:39 -0500
Received: by iyi12 with SMTP id 12so1721340iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:12:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimcALT7STVZyfgaWeCCpfCBM-tchZL94=ONLUL3@mail.gmail.com>
References: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
 <1292499024.3612.3.camel@jlt3.sipsolutions.net> <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
 <1292501047.3612.9.camel@jlt3.sipsolutions.net> <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
 <1292502934.3612.15.camel@jlt3.sipsolutions.net> <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
 <1292504020.3612.17.camel@jlt3.sipsolutions.net> <AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
 <20101216174410.GB5677@tux> <AANLkTimcALT7STVZyfgaWeCCpfCBM-tchZL94=ONLUL3@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Dec 2010 11:12:18 -0800
Message-ID: <AANLkTikJC4j91cLXHQkD99Zn+YVfYzXtrevvhYZYDj0T@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
To: Paul Stewart <pstew@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 11:08 AM, Paul Stewart <pstew@google.com> wrote:
> On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Try this:
>
> I'm now on vacation and thousands of miles (and more importantly a few
> firewalls) away from my build system.  If you want to know if this
> works before the end of the end of the year, you can try to replicate
> the conditions (scan active during ieee80211_do_stop()), otherwise we
> can go back to this next year.

2011 looks so futuristic, but yeah I'm sure this can wait, if I get a
chance maybe I'll try to hack my CR48 with my own kernel to test this.
We'll see I guess.

  Luis
