Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:23922 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYJHNaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 09:30:19 -0400
Received: by mu-out-0910.google.com with SMTP id g7so3236367muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 06:30:17 -0700 (PDT)
Message-ID: <1ba2fa240810080630n1a1f26f6pab575d2457ce4cbf@mail.gmail.com> (sfid-20081008_153025_778749_878063A4)
Date: Wed, 8 Oct 2008 15:30:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT capabilities IE
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810080540m32134461t26096022d11c6dfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223460098.3618.53.camel@johannes.berg>
	 <1ba2fa240810080540m32134461t26096022d11c6dfa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2008 at 2:40 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Wed, Oct 8, 2008 at 12:01 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Hi,
>>
>> quick question, I can't seem to read that from the draft, is the HT
>> capabilities IE supposed to be constant when, say, sent from an AP in
>> every beacon? Most fields look very constant, but e.g. the SM power save
>> mode might not be?
>
> SM has to be changed using action frame by the spec IIRC

Sorry, wrong answer in, this is only the STA side.

There is whole section about Legacy HT coexistence when connection
parameters changes. But  I didn't spent time on it much so I would
have to look into the spec myself
Tomas
