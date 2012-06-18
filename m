Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38661 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRPlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 11:41:51 -0400
Received: by vcbf11 with SMTP id f11so2715846vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 08:41:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120618153852.GA3965@redhat.com>
References: <1339882592-17680-1-git-send-email-xose.vazquez@gmail.com>
	<CAL1gcdNwChERae_B7S_TpZmi=Pi2MwUbDiwh+SFys8px96TFDA@mail.gmail.com>
	<20120618153852.GA3965@redhat.com>
Date: Mon, 18 Jun 2012 17:41:50 +0200
Message-ID: <CAOZOX0W6201miGkmjhEx2HPBPK2fjKPu_oabH60OqtQpeM_Uyw@mail.gmail.com> (sfid-20120618_174154_228337_FBE78E16)
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800: remove
 unsupported rf and chips
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2012 at 5:38 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jun 18, 2012 at 11:01:54AM +0200, Gertjan van Wingerde wrote:
>> Hi Xose,
>>
>> On Sat, Jun 16, 2012 at 11:36 PM, Xose Vazquez Perez
>> <xose.vazquez@gmail.com> wrote:
>> > removed, no support for:
>> >
>> > RF2853 2.4G/5G 3T3R
>> > RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
>> > RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
>> >
>> > RT3593
>> > RT3883
>> >
>> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>
>> I don't mind removing the RT chipset definitions, but I would like to
>> retain the RF chipset definitions. Even
>> though these definitions are not used in the code, the do represent
>> values we could see from devices, so
>> I consider the list to be documentation as well.
>
> Perhaps we can comment them out, as compromise :-)

Personally I don't see the point. In my opinion the defines can all
stay as they are.
They are all defines which are clearly related to the chipsets
themselves, so they are
useful, and the fact that they are currently unused shouldn't mean
they should be
deleted.

Ivo
