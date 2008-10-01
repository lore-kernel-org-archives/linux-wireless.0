Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34260 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYJASjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 14:39:33 -0400
Received: by gxk9 with SMTP id 9so560157gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 11:39:32 -0700 (PDT)
Message-ID: <43e72e890810011139r1b9b9716se0e542a1b066314a@mail.gmail.com> (sfid-20081001_203938_024235_0C7E3620)
Date: Wed, 1 Oct 2008 11:39:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS mode
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222885309.7064.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 <1222619168.7064.3.camel@johannes.berg>
	 <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com>
	 <1222622474.7064.6.camel@johannes.berg>
	 <1ba2fa240810010340t14dce3a0p46b834f39d66f6b2@mail.gmail.com>
	 <20081001111415.GA6126@tesla> <1222885309.7064.71.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 1, 2008 at 11:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-01 at 04:14 -0700, Luis R. Rodriguez wrote:
>> On Wed, Oct 01, 2008 at 03:40:08AM -0700, Tomas Winkler wrote:
>> >
>> > Fresh from Intel
>> > http://www.cambridge.org/catalogue/catalogue.asp?isbn=9780521885843
>>
>> Very cool. Its $70 though. I am hoping we can help move this forward:
>>
>> http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
>
> I really don't think we should try to explain all this stuff to people,
> we're stretched thin in terms of being able to work on things already...

I'm aiming at just the basics. Without that all this is voodoo.

  Luis
