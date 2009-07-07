Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:35104 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZGGSm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 14:42:56 -0400
Received: by pzk31 with SMTP id 31so3157319pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 11:42:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090705120515.GA6329@hash.localnet>
References: <4A3B5B11.7060103@bitnet.be>
	 <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com>
	 <b6c5339f0906191019ve40014dp98af5ada875e2a24@mail.gmail.com>
	 <45e8e6c40906191042k5c96d3a6wff85358da22a7b92@mail.gmail.com>
	 <20090705120515.GA6329@hash.localnet>
Date: Tue, 7 Jul 2009 11:42:53 -0700
Message-ID: <45e8e6c40907071142l3edf9133sd8c3758175c7ae3c@mail.gmail.com>
Subject: Re: current status of 802.11s mesh in ath5k ?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Hans Maes <Hans@bitnet.be>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 5, 2009 at 5:05 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Fri, Jun 19, 2009 at 10:42:22AM -0700, Andrey Yurovsky wrote:
>> > I have been working on a patch to rework the beaconing, namely using
>> > bss_conf->enable_beacon and calling beacon_config whenever the beacon
>> > interval or beacon changes, that might fix it but I'm not too familiar
>> > with mesh details to say.
>>
>> 'looking forward to that patch.  From the driver side, there's not
>> much difference between mesh beaconing and AP or IBSS beaconing.
>
> Can you check whether my most recent patch (I think it was 2/5 in the
> ath5k series) helps?  I looked at mac80211 and it seems we set
> enable_beacon properly in mesh mode so that should configure beaconing
> to start.

Thanks Bob, I confirm that your patch fixes mesh beaconing.

  -Andrey
