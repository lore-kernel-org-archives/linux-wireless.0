Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60008 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZKCUod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 15:44:33 -0500
Received: by ewy3 with SMTP id 3so2397784ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 12:44:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091103192735.GA11145@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de>
	 <200910291431.48388.mb@bu3sch.de>
	 <20091031202156.GA29825@hash.localnet>
	 <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
	 <20091101131652.GA30381@hash.localnet>
	 <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
	 <20091102194349.GA7709@hash.localnet>
	 <40f31dec0911021336l45d185fewa5ce1ffb88f7db97@mail.gmail.com>
	 <20091103192735.GA11145@hash.localnet>
Date: Tue, 3 Nov 2009 22:44:36 +0200
Message-ID: <40f31dec0911031244y5ca7219y30ed2139a5c4ab93@mail.gmail.com>
Subject: Re: ath5k AP issues
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/3 Bob Copeland <me@bobcopeland.com>:
> On Mon, Nov 02, 2009 at 11:36:22PM +0200, Nick Kossifidis wrote:
>> Well let's enable them both :P
>>
>> I still think that ready-time thing is evil, we should use a more accurate
>> way.
>
> I don't follow, you want to try both DBA and BCN_SENT to see what happens
> (with/without ready-time)?
>

Yup, without ready-time.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
