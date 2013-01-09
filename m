Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61836 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3AISGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 13:06:03 -0500
Received: by mail-bk0-f49.google.com with SMTP id jm19so1091373bkc.22
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 10:06:01 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Date: Wed, 9 Jan 2013 19:05:57 +0100
Cc: Johan Danielsson <joda@kth.se>, linux-wireless@vger.kernel.org
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com> <201301091446.44597.chunkeey@googlemail.com> <1357739673.9757.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357739673.9757.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201301091905.58042.chunkeey@googlemail.com> (sfid-20130109_190607_702688_F51AC36B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 09, 2013 02:54:33 PM Johannes Berg wrote:
> On Wed, 2013-01-09 at 14:46 +0100, Christian Lamparter wrote:
> Why do we even tear down RX sessions at all?

ti's wl1271 has fixed rx ba agreement limit.

Also 802.11-2012 10.5.4 states:

"Every STA shall maintain an inactivity timer for every negotiated
Block Ack Setup. [then it goes on what the originator and recipient
should do...]". The recipient needs to be able to tear down BA 
session too.

Regards,
	Chr
