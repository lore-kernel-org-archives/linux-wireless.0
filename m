Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:59179 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZG0Tl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:41:27 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1766967qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 12:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248721724.32365.1.camel@johannes.local>
References: <1248721179-16079-1-git-send-email-lrodriguez@atheros.com>
	<1248721724.32365.1.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Jul 2009 12:41:07 -0700
Message-ID: <43e72e890907271241m7ccf386aj97097bb715e32658@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: redefine usage of the mac80211 workqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 12:08 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-07-27 at 11:59 -0700, Luis R. Rodriguez wrote:
>
>> +EXPORT_SYMBOL_GPL(ieee80211_queue_work);
>
> Do we really want to allow these as _GPL only? Most things are not _GPL
> but usable by anyone, which of course isn't too useful since mac80211
> changes all the time :)

Well I don't see why not.

  Luis
