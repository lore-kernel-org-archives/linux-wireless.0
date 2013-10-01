Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59421 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3JAWjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 18:39:20 -0400
Received: by mail-oa0-f43.google.com with SMTP id f4so4303oah.30
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 15:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380626864.14430.32.camel@jlt4.sipsolutions.net>
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	<1379115372-28426-5-git-send-email-yeohchunyeow@cozybit.com>
	<1380626864.14430.32.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 06:39:20 +0800
Message-ID: <CAHS2MGOGJ4d2W5fWeHivkV6f4KrSMYxur24DG7R+pk-4SPJ38g@mail.gmail.com> (sfid-20131002_003923_156990_19FD0A99)
Subject: Re: [PATCH 4/5] {nl,cfg,mac}80211: finalizing mesh channel switching
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'd prefer you rewrote this to be more active ... this seems rather
> observer style :)
Alright.

>
> This seems totally racy with what I pointed out in the other patch ...
>
Definitely take a look on this.

> You should never print a message for memory allocation failures, they
> already give very verbose output.
Ok.

>> +     ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
>> +     return ret;
>
> return 0
Ok

--- Chun-Yeow
