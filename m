Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:23849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZIARsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:48:01 -0400
Received: by fg-out-1718.google.com with SMTP id 22so156382fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 10:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090901173822.GG8261@mosca>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
	<20090901163300.GA29047@jm.kir.nu> <20090901171848.GF8261@mosca>
	<69e28c910909011028i25fba508t9e68fb24168193eb@mail.gmail.com>
	<20090901173822.GG8261@mosca>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 1 Sep 2009 19:47:43 +0200
Message-ID: <69e28c910909011047p2ecb7f9fg84b4089a70d1be5c@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/1 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Tue, Sep 01, 2009 at 10:28:35AM -0700, Gábor Stefanik wrote:
>> On Tue, Sep 1, 2009 at 7:18 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
>> > On Tue, Sep 01, 2009 at 09:33:00AM -0700, Jouni Malinen wrote:
>> >> On Tue, Sep 01, 2009 at 08:54:25AM -0700, Luis R. Rodriguez wrote:
>> >> > +       SoftMAC devices. SoftMAC devices allow for a finer control of the
>> >>
>> >> Again, I don't really like the term "SoftMAC" here..
>> >
>> > What's a better term?
>> >
>>
>> "Software-based", "Software-MAC", "Software-defined", or anything that
>> neither implies that the stack is designed for PrismGT (the
>> capitalization "SoftMAC" comes from Intersil AFAIK), nor allows
>> confusion with ieee80211softmac (which could result if we write it
>> with all small letters as "softmac").
>
> Indeed, I picked up 'SoftMAC' and 'FullMAC' terminology from the prism54 days
> after they decided to move in that direction as others were or already had. For
> better or for worse I have been using 'SoftMAC' throughout wireless.kernel.org
> documentation to distinguish between 'FullMAC' cards. I really have not been
> able to find any other suitable replacements, are there legal reasons to not use
> such terms?
>
> I thought 'mac80211' name was brilliant as it highlighted the main focus for the
> module, to focus on the MAC frame processing, I just cannot think of any
> description for it other than something to support SoftMAC cards.

The description isn't the problem - the term "SoftMAC" is, due to its
connections with ieee80211softmac. Even "Software MAC" would be better
here.

>
>  Luis
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
