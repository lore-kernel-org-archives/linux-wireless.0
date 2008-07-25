Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:53412 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYGYTpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 15:45:25 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4292913wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 12:45:24 -0700 (PDT)
Message-ID: <40f31dec0807251245h40ef042lbb40a5f2a8ad7b29@mail.gmail.com> (sfid-20080725_214528_581917_9D256115)
Date: Fri, 25 Jul 2008 22:45:24 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 1/12] ath5k: Update register list
Cc: "Pavel Roskin" <proski@gnu.org>, jirislaby@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Nick Kossifidis" <mick@madwifi.org>
In-Reply-To: <b6c5339f0807241455s31697c8ctfcb9e78a486a28ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720033041.GA7440@makis> <1216934605.3094.5.camel@dv>
	 <40f31dec0807241435x2e9f6ae1x1d136c1b0d20c874@mail.gmail.com>
	 <b6c5339f0807241455s31697c8ctfcb9e78a486a28ea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/25 Bob Copeland <me@bobcopeland.com>:
> On Thu, Jul 24, 2008 at 5:35 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>>>> -                     ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
>>>> +                     ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
>>>
>>> You are replacing macros with numbers in several places.  Maybe you
>>> could introduce another macro?  Or is it the case when you had
>>> interpretation of the registers, but now realize that it was wrong?
>>>
>>
>> Helps me with rev. engineering, i'll hopefully introduce a macro for
>> these registers soon...
>
> Probably stating the obvious, but ath9k demystifies some of these registers
> perhaps?  I'm not sure how much the phy register location changes each
> revision, but the bit pattern looks like 0x982c could easily be
> AR_PHY_ADC_CTL...
>
> --
> Bob Copeland %% www.bobcopeland.com
>

Give me some time on this, I think this patch is ok for now, we can
update it in the future...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
