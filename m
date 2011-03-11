Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:34636 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1CKVWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 16:22:54 -0500
Received: by pxi2 with SMTP id 2so792659pxi.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 13:22:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110309035146.GA16481@hash.localnet>
References: <1299620160-27837-1-git-send-email-linville@tuxdriver.com>
	<20110309035146.GA16481@hash.localnet>
Date: Fri, 11 Mar 2011 23:22:52 +0200
Message-ID: <AANLkTim8+8Bpju1XCpdDRw3kbg28GD5SQpZgh584QhT3@mail.gmail.com>
Subject: Re: [PATCH] ath5k: restrict AR5K_TX_QUEUE_ID_DATA_MAX to reflect the
 [0,3] range
From: Nick Kossifidis <mickflemm@gmail.com>
To: me@bobcopeland.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/9  <me@bobcopeland.com>:
> On Tue, Mar 08, 2011 at 04:36:00PM -0500, John W. Linville wrote:
>> This just matches reality...
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>> ..or am I missing something?
>
> No, your change looks right to me.
>
> Acked-by: Bob Copeland <me@bobcopeland.com>
>
> --
> Bob Copeland %% www.bobcopeland.com
>

Yup this is left from early dadwifi days, thanks for catching it ;-)
(http://johannes.sipsolutions.net/files/mac80211.h.txt)

We have to do some more cleanup on ath5k.h...

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
