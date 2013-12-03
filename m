Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47058 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3LCGYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 01:24:43 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so20438681pbb.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 22:24:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com>
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	<1385890375.4171.0.camel@jlt4.sipsolutions.net>
	<CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com>
Date: Tue, 3 Dec 2013 11:54:42 +0530
Message-ID: <CAE2MWkn8fkosqF8SztJRUuhU5bE-OPPL3oWUjRz6XSQynd5mUw@mail.gmail.com> (sfid-20131203_072446_317952_547074F4)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired BSS
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Are there any update about my arguments?

Thanks,
UjjaL Roy


On Mon, Dec 2, 2013 at 10:49 AM, Ujjal Roy <royujjal@gmail.com> wrote:
> So, can you please tell me what type of bugs or what bugs the cfg80211
> going to catch? As I see cfg80211 allows re-assoc command and the
> driver is able to get a BSS using the function cfg80211_get_bss(). So,
> the driver is going to re-associate and the result is a Kernel warning.
> At this point driver's internal association is successful though.
>
> On Sun, Dec 1, 2013 at 3:02 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Sun, 2013-12-01 at 13:01 +0530, Ujjal Roy wrote:
>>> cfg80211 allows re-association in managed mode and if a user
>>> wants to re-associate to the same AP network after the time
>>> period of IEEE80211_SCAN_RESULT_EXPIRE, cfg80211 warns with
>>> the following message on receiving the connect result event.
>>
>> This behaviour is intentional to point out driver bugs. I'm not applying
>> this.
>>
>> johannes
>>
