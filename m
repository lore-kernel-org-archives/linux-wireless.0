Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:55628 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbZGPQty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:49:54 -0400
Received: by qyk30 with SMTP id 30so229912qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 09:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247762613.30529.33.camel@johannes.local>
References: <200907161104.41975.helmut.schaa@gmail.com> <200907161108.57436.helmut.schaa@gmail.com>
	<43e72e890907160930ra5111e1qac13701aed15974e@mail.gmail.com>
	<1247762613.30529.33.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 09:49:33 -0700
Message-ID: <43e72e890907160949u107441fal6692746ca5edc3c7@mail.gmail.com>
Subject: Re: [RFC/RFT 4/5] mac80211: Replace {sw,hw}_scanning variables with a
	bitfield
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 9:43 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-16 at 09:30 -0700, Luis R. Rodriguez wrote:
>> On Thu, Jul 16, 2009 at 2:08 AM, Helmut
>> Schaa<helmut.schaa@googlemail.com> wrote:
>> > Use a bitfield to store the current scan mode instead of two boolean
>> > variables {sw,hw}_scanning. This patch does not introduce functional
>> > changes.
>> >
>>
>> > +enum mac80211_scan_flag {
>> > +       SCAN_SW_SCANNING = 1,
>> > +       SCAN_HW_SCANNING = 2,
>> > +};
>> > +
>>
>> But why is that needed? The commit log doesn't state that. We won't
>> use both at the same time.
>
> You're nitpicking ;)
> We currently have two variables, and this just changes them into two
> bits instead, so he can extend the sw-scanning case with another bit :)

I didn't realize that until reading the next patch.

 Luis
