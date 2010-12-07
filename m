Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55708 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0LGDJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 22:09:45 -0500
Received: by iwn9 with SMTP id 9so993695iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 19:09:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19704.23185.565826.890275@gargle.gargle.HOWL>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Dec 2010 19:09:24 -0800
Message-ID: <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: Sujith <m.sujith@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 6:48 PM, Sujith <m.sujith@gmail.com> wrote:
> John W. Linville wrote:
>> On Wed, Dec 01, 2010 at 12:30:27PM +0530, Sujith wrote:
>> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>> >
>> > The HW has to be set to FULLSLEEP mode during suspend,
>> > when no interface has been brought up. Not doing this would
>> > break resume, as the chip won't be powered up at all.
>> >
>> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>>
>> Is this intended for 2.6.37?  It looks like it will apply there.
>
> Thanks for pointing this out and yes, this would be a candidate for 2.6.37

Just curious, if you revert this patch and apply the ones I just
posted, does it fix it, or is this patch required either way?

  Luis
