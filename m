Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51326 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab0EKSSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:18:17 -0400
Received: by pwi5 with SMTP id 5so2406967pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 11:18:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005111834.36879.br1@einfach.org>
References: <20100511083121.28289.96180.stgit@tt-desk> <1273567999.3669.27.camel@jlt3.sipsolutions.net>
	<201005111834.36879.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 11 May 2010 11:17:57 -0700
Message-ID: <AANLkTinovE4SfYj3bzVo1GJcSciiT0Tt1RB8Mz-rXWeR@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mac80211: antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 2:34 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Tuesday 11 May 2010 17:53:19 you wrote:
>> On Tue, 2010-05-11 at 17:38 +0900, Bruno Randolf wrote:
>> > i have followed holger schurig's suggestion to use a bitmap for allowed
>> > antennas. when multiple antennas are selected in the bitmap, the driver
>> > may use diversity. i think that this allows for the most flexible, yet
>> > simple configuration of antennas, and drivers can just reject
>> > configurations they cannot support. i hope that this will also be
>> > generic enough for 802.11n with multiple antennas
>>
>> Not sure ... 11n has antennas and chains, but people mix them up
>> frequently. Does this API even make sense for 11n? Use cases? Should it
>> be about *antennas*, or about *chains*?
>
> thanks for the review! i'll resend tomorrow.
>
> i personally don't know about 802.11n - and what i need is about *antennas* :)

I figured, let us help you with the 11n review.

  Luis
