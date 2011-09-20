Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50507 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1ITU5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 16:57:15 -0400
Received: by eya28 with SMTP id 28so501683eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 13:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316524874.3953.41.camel@jlt3.sipsolutions.net>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<1316524874.3953.41.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Sep 2011 22:56:49 +0200
Message-ID: <CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com> (sfid-20110920_225718_164001_E4AA9FE0)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/20 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2011-09-20 at 06:03 -0700, Greg KH wrote:
>
>> And while code is great and nice, I still haven't seen any real answers
>> to all of the questions that were asked of the Broadcom driver team
>> during that review by the linux-wireless developers about how things
>> will be handled properly due to the overlap in functionality with the
>> existing "real" driver in the tree.
>
> Let's qualify this to "some developers".
>
> One thing I'd like to point out is that the Broadcom's firmware API has
> always undergone changes over time. I'm actually surprised that b43
> works as well as it does (which, tbh, isn't very well at all, at least
> for me with some 11n PHY). I also don't think that Broadcom are going to
> maintain compatibility and/or maintain new firmware features for old
> devices, that just doesn't make any sense.

Actually, when we got some single response from Broadcom about their
relation to b43, they haven't mentioned support for old HW is any
problem at all. They just pointed we don't support calibration for
N-PHY and we don't support 802.11n feature for a better performance.

I feel we're creating some problems ourself. Just some guessing that
support for older HW can be real problem for future development... not
confirmed by anyone at all.

-- 
Rafał
