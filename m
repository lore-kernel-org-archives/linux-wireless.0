Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:47422 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZJZOTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:19:42 -0400
Received: by iwn10 with SMTP id 10so5973978iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 07:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910212042i6a6a1bc3h1cd2a742f462353f@mail.gmail.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
	<43e72e890910212042i6a6a1bc3h1cd2a742f462353f@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Oct 2009 07:19:26 -0700
Message-ID: <43e72e890910260719j508670a8p87bb7a5cf31d843d@mail.gmail.com>
Subject: Re: [RFT 00/15] ath9k_hw ar9271 updates & AR5416 force bias
To: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 8:42 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Oct 19, 2009 at 3:33 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> This series started off to extend support for ar9271 on ath9k_hw
>> but after review of the phy related code I noticed a fix for
>> AR5416 was only partially being implemented and used for all
>> chipsets. This series then adds the changes I've noticed so far
>> required for ar9271 but also fixes and completes the orientation
>> fix for AR5416 (force bias). Since I'm touching phy.c I also extend
>> documentation for it.
>>
>> I don't have AR9285 cards with me but I do have an AR5416 cardbus
>> card -- I'd appreciate it if someone can give this a test on AR9285

Alright well I made it back to California and tested an AR9285 and
things are peachy so I will submit this now.

  Luis
