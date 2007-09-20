Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:44973 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXITV0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 17:26:09 -0400
Received: by nf-out-0910.google.com with SMTP id g13so585422nfb
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2007 14:26:08 -0700 (PDT)
Message-ID: <46F2E56D.1040606@gmail.com>
Date: Thu, 20 Sep 2007 23:26:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k - Fix filters for AR5212, correct return values  for WEP
References: <43e72e890709201413w4cee6ea5v799f4b88e1982e5a@mail.gmail.com>	 <46F2E3A9.2040605@gmail.com> <43e72e890709201424k3a18a5cbnbbb488dbf5bb19d3@mail.gmail.com>
In-Reply-To: <43e72e890709201424k3a18a5cbnbbb488dbf5bb19d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2007 11:24 PM, Luis R. Rodriguez wrote:
> On 9/20/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>     int ret = 0;
>> +       switch(key->alg) {
>> +        case ALG_WEP:
>> +               break;
>> +        case ALG_TKIP:
>> +        case ALG_CCMP:
>> +               return -EOPNOTSUPP;
>>
>> Some broken whitespace here :).
> 
> You mean all the extra spaces on the left instead of Tabs? If so then
> ACK, attached v2.

Yes, nice.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
