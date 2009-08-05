Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:48837 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZHES7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:59:08 -0400
Received: by ywh13 with SMTP id 13so409279ywh.15
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 11:59:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090805181726.GC20338@tuxdriver.com>
References: <1248285108-10059-1-git-send-email-lrodriguez@atheros.com>
	<f7de31c0907290313x148e2851i26df034c8e701a8c@mail.gmail.com>
	<43e72e890907290818t62515b61p2f30278b690f22c@mail.gmail.com>
	<f7de31c0907292242s7c41daefr6ca7b3423180d005@mail.gmail.com>
	<f7de31c0907292246h6002e9bdod9691c2f24456017@mail.gmail.com>
	<20090805181726.GC20338@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 5 Aug 2009 11:58:48 -0700
Message-ID: <43e72e890908051158q17114384i96ff4fa4c54d9b03@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: TH gets 5 GHz enabled as of new
	regulatory rules
To: "John W. Linville" <linville@tuxdriver.com>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Cc: Phattanon Duangdara <sfalpha@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this e-mail is on a public mailing list.

Adding Michael and David again.

On Wed, Aug 5, 2009 at 11:17 AM, John W. Linville<linville@tuxdriver.com> wrote:
> On Thu, Jul 30, 2009 at 12:46:29PM +0700, Phattanon Duangdara wrote:
>> On Wed, Jul 29, 2009 at 10:18 PM, Luis R.
>> Rodriguez<lrodriguez@atheros.com> wrote:
>> > Note: this e-mail is in a public mailing list.
>> >
>> > Adding Michael and David. Michael, I'd appreciate your review on this,
>> > if possible.
>> >
>> > Phattanon, thanks for your review of the TH document and sharing it
>> > with us. Please see my reply inline below.
>> >
>> > On Wed, Jul 29, 2009 at 3:13 AM, Phattanon Duangdara<sfalpha@gmail.com> wrote:
>> >> I corrected redgb from my knowledge.
>> >
>> > Did you see my patch? I corrected TH to be:
>> >
>> > country TH:
>> >        (2402 - 2482 @ 20), (N/A, 20)
>> >        (5170 - 5250 @ 20), (3, 17)
>> >        (5250 - 5330 @ 20), (3, 20), DFS
>> >        (5490 - 5710 @ 20), (3, 20), DFS
>> >        (5735 - 5835 @ 20), (3, 30)
>> >
>> >> For 5150-5350 is for Indoor Use Only.
>> >> Most of the regulartory
>> >
>> > What do you mean by that? Do you mean that the document refers to FCC
>> > and ETSI/ITU standard for regulatory purposes for some items?
>> >
>> >> refer _either_ FCC or ETSI/ITU standard, so I
>> >> guess that from the document 40MHz can also be used (same as US)
>> >> because TH regulatory mostly cover all bandwidth on 40MHz.
>> >
>> > Are you saying the Thailand document refers to FCC for max allowed
>> > bandwidth spacing and therefore US max bandwidth spacing should be
>> > used (ie allow 40 MHz width channels)?
>>
>> I am not sure about this. But if equipment that comply with FCC
>> standard allow to use 40MHz, I think we can because, for example
>> Translated rule for 2.4GHz says
>
> <snip>
>
> So, is the patch from Luis wrong?  If so, what is the correct patch?

Although Phattanon didn't post a patch I interpreted it as he was
suggesting we can enable 40 MHz channels on Thailand as well since he
points out that Thailand regulatory rules refer to the FCC for
bandwidth compliance.

Michael does this interpretation match yours? Can we allow 40 MHz in TH?

Phattanon also specified some differences on max EIRP but I think that
should go as a separate patch and reviewed as such.

  Luis
