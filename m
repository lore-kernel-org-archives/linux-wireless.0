Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f52.google.com ([209.85.215.52]:42587 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUNzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 09:55:13 -0400
Received: by ewy19 with SMTP id 19so1473647ewy.11
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 06:55:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzOsbi0ghDUa1ruNq4uefEWmwdU7KUDRrh6r0927Jm9oQ@mail.gmail.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<1316524874.3953.41.camel@jlt3.sipsolutions.net>
	<CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com>
	<20110921134056.GB2828@tuxdriver.com>
	<CACna6rzOsbi0ghDUa1ruNq4uefEWmwdU7KUDRrh6r0927Jm9oQ@mail.gmail.com>
Date: Wed, 21 Sep 2011 15:55:12 +0200
Message-ID: <CACna6rwiWp+eEv+K+zm0VBFC6h4GHnMYrx2g8nk-vaBNpFbMyQ@mail.gmail.com> (sfid-20110921_155518_041935_C4AB6DC7)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 21 września 2011 15:52 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> W dniu 21 września 2011 15:40 użytkownik John W. Linville
> <linville@tuxdriver.com> napisał:
>> On Tue, Sep 20, 2011 at 10:56:49PM +0200, Rafał Miłecki wrote:
>>> 2011/9/20 Johannes Berg <johannes@sipsolutions.net>:
>>> > On Tue, 2011-09-20 at 06:03 -0700, Greg KH wrote:
>>> >
>>> >> And while code is great and nice, I still haven't seen any real answers
>>> >> to all of the questions that were asked of the Broadcom driver team
>>> >> during that review by the linux-wireless developers about how things
>>> >> will be handled properly due to the overlap in functionality with the
>>> >> existing "real" driver in the tree.
>>> >
>>> > Let's qualify this to "some developers".
>>> >
>>> > One thing I'd like to point out is that the Broadcom's firmware API has
>>> > always undergone changes over time. I'm actually surprised that b43
>>> > works as well as it does (which, tbh, isn't very well at all, at least
>>> > for me with some 11n PHY). I also don't think that Broadcom are going to
>>> > maintain compatibility and/or maintain new firmware features for old
>>> > devices, that just doesn't make any sense.
>>>
>>> Actually, when we got some single response from Broadcom about their
>>> relation to b43, they haven't mentioned support for old HW is any
>>> problem at all. They just pointed we don't support calibration for
>>> N-PHY and we don't support 802.11n feature for a better performance.
>>>
>>> I feel we're creating some problems ourself. Just some guessing that
>>> support for older HW can be real problem for future development... not
>>> confirmed by anyone at all.
>>
>> Their new firmware doesn't run on the older hardware, no?
>
> AFAIK it does (unless you mean hardware covered by b43legacy).
>
> If you take a look at 666.2 firmware, it's still available for core 5
> (and 9, 13, etc.)

The reason I've added support for new firmware without dropping
support for older, was users experience. I didn't want to leave anyone
with b43 not working after kernel update (without firmware update).

-- 
Rafał
