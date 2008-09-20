Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61896 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITVFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:05:22 -0400
Received: by gxk9 with SMTP id 9so1859023gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:05:21 -0700 (PDT)
Message-ID: <43e72e890809201405u63f57680u63ce0329c8cd31a2@mail.gmail.com> (sfid-20080920_230526_408256_6EF41305)
Date: Sat, 20 Sep 2008 14:05:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for Motorola 7010 variant of BCM4306
Cc: "Michael Buesch" <mb@bu3sch.de>, bbullins@triad.rr.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1221944575.3023.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de>
	 <1221943895.3023.1.camel@johannes.berg>
	 <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com>
	 <1221944575.3023.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 2:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-09-20 at 13:59 -0700, Luis R. Rodriguez wrote:
>> On Sat, Sep 20, 2008 at 1:51 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sat, 2008-09-20 at 17:44 +0200, Michael Buesch wrote:
>> >> On Friday 19 September 2008 21:47:38 Larry Finger wrote:
>> >> > An additional BCM4306 has been found with the Bluetooth coexistence
>> >> > SPROM coding error.
>> >
>> > Does anyone actually make laptops that use these bluetooth coexistence
>> > pins? All CSR bluetooth chips do it automatically I'm told, maybe we
>> > should just kill them completely.
>>
>> Regardless of the wireless card? Or just for bcm?
>
> Well just for b43(legacy), but out of curiosity, does any BT chip use
> these pins anyway? Well I guess _somebody_ has to buy BCMs BT chips,
> but ...

BCM BT chips? I thought you said CSR?

  Luis
