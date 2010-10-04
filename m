Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46850 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab0JDVM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 17:12:59 -0400
Received: by ewy23 with SMTP id 23so2256629ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 14:12:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286219405.3620.56.camel@jlt3.sipsolutions.net>
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net>
 <4CAA252F.9090102@candelatech.com> <1286219405.3620.56.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 14:12:36 -0700
Message-ID: <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 12:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
>> On 10/04/2010 12:01 PM, Johannes Berg wrote:
>> > On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>> >> Just in case this seems familiar to anyone...
>> >>
>> >> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>> >
>> > Do you have debug info that'd point to a code line?
>> >
>> > I have never heard of this.
>>
>> I don't actually know how to get a line of code out of those
>> hex offsets...
>>
>> Someone told me many years ago..but I lost that information :P
>
> Err, I never remember either, I think Luis knows the gdb thing ... I
> usually use "objdump -dS"

gdb net/mac80211/mac80211.ko
l *(ieee80211_stop_tx_ba_session+0x14/0x84)


  Luis
