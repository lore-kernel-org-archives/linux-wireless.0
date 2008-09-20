Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:31956 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYITVsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:48:03 -0400
Received: by qb-out-0506.google.com with SMTP id f11so746273qba.17
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:48:01 -0700 (PDT)
Message-ID: <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com> (sfid-20080920_234815_928956_84996B65)
Date: Sat, 20 Sep 2008 14:48:00 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
	 <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
	 <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com>
	 <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 2:26 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sat, Sep 20, 2008 at 2:22 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>
>> Heh. I don't have an Xbox 360 or PS3 (sad, I know). Do have several
>> 2.4GHz phones. ;)
>
> Microwaves are the best to make the signal wet poop BTW, if you have
> that option available. Not sure if we can trigger the device that way
> but I'm just brainstorming here.
>

Well, I've got the thing set to ATH_DBG_ANY (I want this damn bug
found!), which will certainly be *interesting*. In 5 minutes, the log
has jumped 9 megabytes.

I've also got sadc monitoring IRQs so I know for certain when the
interrupt storm starts.

I'll let you know how this goes.

- Steven
