Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:45069 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZBVLtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 06:49:15 -0500
Received: by fxm11 with SMTP id 11so932171fxm.13
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2009 03:49:13 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	<8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	<87fxibhr5q.fsf@litku.valot.fi>
	<c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com>
	<87hc2okyrm.fsf@litku.valot.fi>
	<c4d76b3b0902211344j5cefcdd3p4e34ddc0ac5d78d@mail.gmail.com>
	<c4d76b3b0902211400t7f5909d1o9ea8325f40db2aff@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Feb 2009 13:49:11 +0200
In-Reply-To: <c4d76b3b0902211400t7f5909d1o9ea8325f40db2aff@mail.gmail.com> (Jason Andryuk's message of "Sat\, 21 Feb 2009 17\:00\:41 -0500")
Message-ID: <87tz6md748.fsf@litku.valot.fi> (sfid-20090222_124917_993815_C6F3A1BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Sat, Feb 21, 2009 at 4:44 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
>> I was trying at76_usb + mac80211 when that was in staging, but I have
>> not tried ~ at76c503a.berlios.de staging version.  I can take a look.
>
> at76_usb in staging does not compile.

This is in linux-wireless, right? That's because net/ieee80211.h was
just removed. I'll have a patch ready for at76_usb and I'll send it to
Greg.

at76_usb compiles in Linus' tree (ie. linux-2.6), though. Or if you
want to use wireless-testing wait for my patch.

-- 
Kalle Valo
