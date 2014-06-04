Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52430 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaFDRLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:11:23 -0400
Message-ID: <538F533A.3050808@candelatech.com> (sfid-20140604_191126_868586_9B265FBB)
Date: Wed, 04 Jun 2014 10:11:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com> <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
In-Reply-To: <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2014 02:04 AM, Michal Kazior wrote:

>> +               if (dbufp == dbg_hdr.dbuf) {
>> +                       /* It is a circular buffer it seems, bail if next
>> +                        * is head
>> +                        */
> 
> Hmm, we seem to be mixing comment styles in ath10k now I guess (this
> applies to other instances of multi-line comments in your patch). What
> multi-line comment style should we really be using in ath10k? Kalle?

Check-patch bitches if you do it differently than what is above, so I say
we keep it as I have it.  Not worth cleaning up other comments to match
unless someone actually cares enough to do it...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

