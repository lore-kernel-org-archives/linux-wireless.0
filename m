Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.147]:7193 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZGFPFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 11:05:34 -0400
Received: by ey-out-1920.google.com with SMTP id 3so870675eyh.36
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 08:05:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246892257.20908.14.camel@johannes.local>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost> <4A4BA21F.1070101@gmail.com>
	 <43e72e890907011112l220874bbu8db8808f666bbd4d@mail.gmail.com>
	 <1246473300.30522.10.camel@localhost.localdomain>
	 <20090701193657.GD3473@tuxdriver.com>
	 <1246884761.20908.11.camel@johannes.local>
	 <4A520DF8.2010500@lwfinger.net>
	 <1246892257.20908.14.camel@johannes.local>
Date: Mon, 6 Jul 2009 18:05:37 +0300
Message-ID: <40f31dec0907060805m2645eb41nb066b1f86a5444ac@mail.gmail.com>
Subject: Re: Insist on cfg80211 for new drivers?
From: Nick Kossifidis <mickflemm@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/6 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2009-07-06 at 09:45 -0500, Larry Finger wrote:
>> Johannes Berg wrote:
>> >
>> > Should we publish something like this:
>> > http://wireless.kernel.org/wext-statement (don't want it indexed by
>> > google yet so you need to log on to view it), for example on lwn? Just
>> > so more application developers are also aware.
>>
>> I made one small grammatical change. In English, "between" is used
>> when dealing with two entities and "among" if more than two. As there
>> are more than two drivers that share cfg80211 features and code...
>
> Subtle! Thanks Larry, I wasn't aware of this distinction.
>
> johannes
>

Another small change...
As such, drivers written without cfg80211 -> As such, drivers written
without cfg80211 support

Looks fine to me too ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
