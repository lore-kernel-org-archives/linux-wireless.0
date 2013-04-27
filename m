Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39021 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3D0S25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 14:28:57 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so1156173eek.24
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 11:28:56 -0700 (PDT)
Message-ID: <517C18A4.70402@unicz.it> (sfid-20130427_202912_729293_3CCFDA18)
Date: Sat, 27 Apr 2013 20:27:48 +0200
From: Paolo Zaffino <p.zaffino@unicz.it>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: Intel Centrino Wireless-N 2230 (rev c4) bug
References: <517BD02A.5060904@unicz.it>  (sfid-20130427_151940_748350_F10D6AF1) <1367085173.8445.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367085173.8445.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all thanks for your support.
Can you give me any advice on what look for in my system?
I really haven't idea about this strange situation.

Thanks a lot.
Paolo



On 27/04/2013 19:52, Johannes Berg wrote:
> On Sat, 2013-04-27 at 15:18 +0200, Paolo Zaffino wrote:
>
>
>> [ 1756.822019] wlp3s0: deauthenticating from 74:ea:3a:cd:28:42 by local
>> choice (reason=3)
> This is your problem, you're probably running two instances of
> wpa_supplicant or something equally strange.
>
> johannes
>
>


-- 
Paolo Zaffino
Ph.D. Student - Biomedical and Computer Engineering
Dept. of Experimental and Clinical Medicine
"Magna Graecia" University of Catanzaro
viale Europa, 88100 Catanzaro - Italy

