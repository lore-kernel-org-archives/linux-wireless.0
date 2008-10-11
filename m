Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56449 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYJKW3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 18:29:54 -0400
Received: by gxk9 with SMTP id 9so2223901gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 15:29:52 -0700 (PDT)
Message-ID: <43e72e890810111529l1cb14bd2g32e7382b054b0b1b@mail.gmail.com> (sfid-20081012_003026_469755_3DFBADBA)
Date: Sat, 11 Oct 2008 18:29:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] nl80211: export HT capabilities
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223675046.29811.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223547613.22490.41.camel@johannes.berg>
	 <20081009085747.GB11530@tesla>
	 <1223630622.17594.0.camel@johannes.berg>
	 <20081010213610.GB20509@tuxdriver.com>
	 <1223675046.29811.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 5:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-10 at 17:36 -0400, John W. Linville wrote:
>> On Fri, Oct 10, 2008 at 11:23:42AM +0200, Johannes Berg wrote:
>> > On Thu, 2008-10-09 at 01:57 -0700, Luis R. Rodriguez wrote:
>> > > On Thu, Oct 09, 2008 at 03:20:13AM -0700, Johannes Berg wrote:
>> > > > +#define NL80211_BAND_ATTR_HT_CAPA NL80211_BAND_ATTR_HT_CAPA
>> > >
>> > > Typo
>> >
>> > Hmm? Am I too dense?
>>
>> Well, it looks a little useless to define something as itself...
>
> Yeah but you can use that to check "has the nl80211.h I'm compiling
> against defined the HT stuff yet?"

So you're going to #ifdef on the iw nl80211.h?

Can't we use something better and more obvious like defining an
nl80211 version (as kernel version won't do us any good for bleeding
edge wireless-testing users) or something like that?

  Luis
