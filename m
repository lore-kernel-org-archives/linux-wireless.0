Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:54239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXK1OGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 09:06:08 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1526264ugc
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 06:06:07 -0800 (PST)
Message-ID: <474D75D9.7070908@gmail.com> (sfid-20071128_140613_727827_061A168C)
Date: Wed, 28 Nov 2007 15:06:17 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
References: <47494851.4070504@gmail.com> <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com> <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com> <20071127033408.GB5698@jm.kir.nu>
In-Reply-To: <20071127033408.GB5698@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Mon, Nov 26, 2007 at 03:50:00PM +0100, dragoran wrote:
>   
>> btw would it make sense to ratelimit
>>
>> "WEP decrypt failed (ICV)" messages?
>> they are a bit annoying when connected to this network...
>>
>> dmesg  | grep ICV | wc -l
>> 3489
>>
>> after some minutes.
>>     
>
> While I fully agree that these messages should be rate limited, it is
> somewhat surprising to see this large a number of reported ICV failures.
> Does the ipw3945 not filter out FCS errors before passing the frame for
> WEP decryption? Or is there something odd about this network/client
> configuration that makes the client try to decrypt frames that are not
> really for it?
>   
this does not happen with the ipw3945 driver but with the iwl3945 so its 
either something with this driver or mac80211.
