Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:58322 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZGWRVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 13:21:42 -0400
Received: by qw-out-2122.google.com with SMTP id 8so603691qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 10:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907231907.47751.rossi.f@inwind.it>
References: <200907230051.57201.rossi.f@inwind.it> <43e72e890907221556r75256f76yde07109d2af78e28@mail.gmail.com>
	<200907231907.47751.rossi.f@inwind.it>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Jul 2009 10:21:21 -0700
Message-ID: <43e72e890907231021m46139567s3de4ed4cc2812938@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:561
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 10:07 AM, Fabio Rossi<rossi.f@inwind.it> wrote:
> On Thursday 23 July 2009, Luis R. Rodriguez wrote:
>
>> On Wed, Jul 22, 2009 at 3:51 PM, Fabio Rossi<rossi.f@inwind.it> wrote:
>> > I'm using the last wireless-testing.git and I have experienced the
>> > following WARNING:
>> >
>> >  WARNING: at net/mac80211/tx.c:561 ieee80211_tx_h_rate_ctrl+0x3d1/0x470
>> > [mac80211]()
>>
>> Please try a git pull
>
> I was already working with the latest release:
>  v2.6.31-rc3-28452-g5bfcdb0
> so I confirm that I get the warning quite often (every 15 seconds).

What channel is your AP on?
Is your AP 00:0c:f6:xx:xx:xx ?

  Luis
