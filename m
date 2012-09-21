Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:41419 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753684Ab2IUPbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 11:31:24 -0400
Message-ID: <505C8822.6080605@xenotime.net> (sfid-20120921_173128_793446_D24D8BA2)
Date: Fri, 21 Sep 2012 08:30:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: could anyone please help me with make modules error
References: <loom.20120921T071134-64@post.gmane.org>
In-Reply-To: <loom.20120921T071134-64@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 10:19 PM, Ouyang wrote:

>> drivers/net/igbvf/igbvf.h: At top level:
>> drivers/net/igbvf/igbvf.h:128:15: error: duplicate member ‘page’
>> make[3]: *** [drivers/net/igbvf/ethtool.o] Error 1
>> make[2]: *** [drivers/net/igbvf] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
> I just google it and one had met the same problem. Is it possible 
> just because of 
> the version of gcc?


1.  Not a question for linux-wireless mailing list.
That driver is not a wireless driver.
Please try the netdev mailing list.

2.  Also specify what kernel version this is, what gcc version
you are using, and if any kernel patches have been applied
locally to the kernel.


-- 
~Randy
