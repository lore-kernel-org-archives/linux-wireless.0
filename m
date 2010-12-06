Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49676 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFXyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 18:54:17 -0500
Received: by wyb28 with SMTP id 28so12625102wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 15:54:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101203145654.GB2348@tuxdriver.com>
References: <20101203041109.GE2988@makis.mantri>
	<AANLkTi=n0wkMTWxJvvNHHMyjvGA25JSr8awWKMJsAv+g@mail.gmail.com>
	<20101203145654.GB2348@tuxdriver.com>
Date: Tue, 7 Dec 2010 01:54:13 +0200
Message-ID: <AANLkTinW-njW6T248ndTT88k-9sBXN8j8UHT5rh_-pLw@mail.gmail.com>
Subject: Re: [PATCH 5/6] ath5k: Update version string
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	me@bobcopeland.com, jirislaby@gmail.com, nbd@openwrt.org,
	br1@einfach.org, sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/3 John W. Linville <linville@tuxdriver.com>:
> On Thu, Dec 02, 2010 at 08:17:41PM -0800, Luis R. Rodriguez wrote:
>> On Thu, Dec 2, 2010 at 8:11 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> >  * Change version number, we've added various new features lately.
>> >  We need to find a way to maintain this, maybe on each kernel release
>> >  or something. Also remove "EXPERIMENTAL", we aren't experimental any
>> >  more I think ;-)
>> >
>> >  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> > +MODULE_VERSION("0.7.0");
>>
>> How about just remove this all together, the version should go by the
>> kernel or git describe.
>
> ACK -- any objections?
>
> John

I'm OK with it, seems reasonable, after all we track changes on the
wiki page per date with links to commits on git so there is no need to
maintain the version field...
http://wireless.kernel.org/en/users/Drivers/ath5k

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
