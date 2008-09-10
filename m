Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42671 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbYIJWQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:16:34 -0400
Received: by gxk9 with SMTP id 9so15031019gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2008 15:16:33 -0700 (PDT)
Message-ID: <43e72e890809101516m2eab9c35jfab5abca1f54aead@mail.gmail.com> (sfid-20080911_001637_559059_3FB7487D)
Date: Wed, 10 Sep 2008 15:16:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] ath9k: Re-order functions in main.c
Cc: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Jouni Malinen" <Jouni.Malinen@atheros.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1221082753.3804.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080910131927.GA7779@vasanth-lnx.users.atheros.com>
	 <43e72e890809101345i7b5ded8bnb7a8a4e7c16470ff@mail.gmail.com>
	 <1221082753.3804.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 2:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-09-10 at 13:45 -0700, Luis R. Rodriguez wrote:
>> On Wed, Sep 10, 2008 at 6:19 AM, Vasanthakumar Thiagarajan
>> <vasanth@atheros.com> wrote:
>> > Some of the functions in main.c are re-ordered in such
>> > a way that all local functions are defined before mac80211
>> > and pci callbacks.
>>
>> Please split the re-ordering of functions into a separate patch to
>> make it easier for review.
>
> Huh? Wasn't this just the separate patch?

Hehe yes, sorry, I had a long night, nevermind

Acked-by me.

  Luis
