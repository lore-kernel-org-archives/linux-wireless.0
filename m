Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:51676 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYKFXNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 18:13:38 -0500
Received: by wf-out-1314.google.com with SMTP id 27so997876wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 15:13:37 -0800 (PST)
Message-ID: <40f31dec0811061513r2691520ahb63373879a1f9459@mail.gmail.com> (sfid-20081107_001343_375044_1348F058)
Date: Fri, 7 Nov 2008 01:13:37 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix IMR init
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, jirislaby@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <b6c5339f0811031448hc264513v76b25e7cf93ea388@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081103222554.GA3006@makis> <20081103224425.GC6378@tesla>
	 <b6c5339f0811031448hc264513v76b25e7cf93ea388@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/4 Bob Copeland <me@bobcopeland.com>:
> On Mon, Nov 3, 2008 at 5:44 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Mon, Nov 03, 2008 at 02:25:54PM -0800, Nick Kossifidis wrote:
>>>  PISR) and under load it results packet loss. Fix the problem by
>>>  unmasking TXDESC and TXEOL on ath5k_init.
>>>
>>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> ACK
>
> Yes, please - worked great here.
>

John any news on this ? Is it ok for inclusion or you want me to
respin/rebase it ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
