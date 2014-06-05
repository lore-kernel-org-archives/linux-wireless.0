Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27489 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFELdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:33:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
Date: Thu, 5 Jun 2014 14:33:06 +0300
In-Reply-To: <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
	(Michal Kazior's message of "Wed, 4 Jun 2014 11:04:57 +0200")
Message-ID: <87y4xboakt.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_133317_696170_D45686A8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> +               dbufp = dbuf.next;
>> +               if (dbufp == dbg_hdr.dbuf) {
>> +                       /* It is a circular buffer it seems, bail if next
>> +                        * is head
>> +                        */
>
> Hmm, we seem to be mixing comment styles in ath10k now I guess (this
> applies to other instances of multi-line comments in your patch). What
> multi-line comment style should we really be using in ath10k? Kalle?

Yeah, checkpatch is really annoying here and started to use that
different style of multiline comments. I just disabled that check on my
own setup. Personally I don't really care, but I guess we should switch
to use this "new" style.

-- 
Kalle Valo
