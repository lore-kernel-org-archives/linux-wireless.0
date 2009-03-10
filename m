Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:8890 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbZCJV6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:58:43 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2826123wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 14:58:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090310223757.a8618b61.cjsthompson@gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <20090304232527.058017da.cjsthompson@gmail.com>
	 <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
	 <20090306084527.5a3b6300.cjsthompson@gmail.com>
	 <4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com>
	 <20090310223757.a8618b61.cjsthompson@gmail.com>
Date: Tue, 10 Mar 2009 17:58:41 -0400
Message-ID: <b6c5339f0903101458k1aaf9455x80a0288daf46a4e3@mail.gmail.com> (sfid-20090310_225850_536939_780ACA13)
Subject: Re: ath5k master (AP) mode
From: Bob Copeland <me@bobcopeland.com>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Cc: Alexey Yudichev <ayudichev@yahoo.co.uk>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 5:37 PM, Christoph .J Thompson
<cjsthompson@gmail.com> wrote:
> On Tue, 10 Mar 2009 21:04:17 +0000
> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>> Do you know, if I got this far, can unstable connection and not
>> working WPA be related to older kernel?
>
> I can't be sure. I don't have the unstable connection problem but I didn't
> use WPA yet. So maybe the unstable connection problem only happens with WPA.

It's possible ath5k has bugs in the crypto for AP mode like the ones fixed
in ath9k recently - you can always try the nohwcrypt=1 modparam.

-- 
Bob Copeland %% www.bobcopeland.com
