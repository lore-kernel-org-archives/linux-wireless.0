Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:47509 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYJAKkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 06:40:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so355756fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 03:40:08 -0700 (PDT)
Message-ID: <1ba2fa240810010340t14dce3a0p46b834f39d66f6b2@mail.gmail.com> (sfid-20081001_124018_081384_5C7FD9B3)
Date: Wed, 1 Oct 2008 13:40:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222622474.7064.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 <1222619168.7064.3.camel@johannes.berg>
	 <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com>
	 <1222622474.7064.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 8:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-28 at 19:39 +0300, Tomas Winkler wrote:
>
>> Second example, only low level driver is running calibrations and
>> knows if it has all rx chains available. The possibility is
>> that not all platforms connect all antennas or physical environment
>> between AP and STA cause some of the antennas not affective
>> we may propagate rx chain status to mac80211 but if this is not
>> opening too much guts. Sometimes it's just hard to keep a clean cut.
>
> That's what I wasn't really aware of. Generally I'd advocate giving
> mac80211 lower-level details though and let it figure out the rest, that
> makes it easier for the driver save copy/pasting code.
>
>> I have two more patches for these to example of course...
>>
>> >I don't actually know what that is anyway though, hence the question.
>>
>> Actually this is one of more understandable part of the spec.
>
> TBH, I've never actually tried to read it, I pick something once a while
> but haven't ever really tried to get a complete overview.
>
>>  We
>> > keep adding API in mac80211 and nobody really knows when to call it.
>> > Maybe you should (maybe team up with Atheros for it) write a "HT
>> > hardware with mac80211" chapter in the documentation?
>>
>> Yes we should.

Fresh from Intel
http://www.cambridge.org/catalogue/catalogue.asp?isbn=9780521885843

Enjoy.
Tomas
