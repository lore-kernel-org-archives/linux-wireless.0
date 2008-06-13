Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:41173 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYFMMhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 08:37:24 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1495662wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 05:37:23 -0700 (PDT)
Message-ID: <48526A00.50306@gmail.com> (sfid-20080613_143727_215775_789C6850)
Date: Fri, 13 Jun 2008 14:37:20 +0200
From: =?ISO-8859-1?Q?Tor_H=E5kon_Haugen?= <tor.hakon.haugen@gmail.com>
MIME-Version: 1.0
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only	with	disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	<1213241315.7814.696.camel@debian.sh.intel.com>	<20080612135936.GA5031@tuxdriver.com>	<1213342523.7814.865.camel@debian.sh.intel.com> <4852344E.7020505@yahoo.it>
In-Reply-To: <4852344E.7020505@yahoo.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to shred some (more confusing) light on this case.

I'm using the iwl3945-driver, and haven't had a problem at home using
HW-scan. At my parents, on the other hand, which uses the same ssid
and the same wep-key, it doesn't work. 1 out of 10 'iwlist scan'
failes to see anything at all.
I haven't tested with disable_hw_scan=1 yet though. But I can try it
the next time I'm visiting them, and post my results here.
Are there anything else information about these APs that anyone might
be interested in? Except for the key? ;-)

- Tor H. Haugen

Filippo Zangheri wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hello everybody.
>
> Zhu Yi ha scritto:
>   
>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>>     
>>> How does the hardware scan differ from what mac80211 does when
>>> scanning?
>>>       
>> Software scan disables Tx during the scan process while hardware scan
>> doesn't. So you are expected to see continous ping responds instead of a
>> freeze during the scan period. Hardware scan is also more efficient
>> since it is handled by the firmware.
>>
>>     
>>> I still see a lot of mysterious iwlwifi (especially iwl3945)
>>> problems in Fedora that seem to disappear with disable_hw_scan=1.
>>>       
>> I don't see this problem from my side. I'll do more testing for 3945.
>>     
>
> Me neither. iwl3945's HW scan has always worked properly on my
> system. It's a 32bit Core2Duo with latest stable vanilla kernel and
> latest compat-wireless driver and mac80211 subsystem.
>
> Never had a single problem with it.
>
> Just a proper-work report.
>
> Thank you for a driver that - at least on my system - is working
> great (even from the speed point of view, but that's another topic).
>
>
>   
>>> Honestly I'm tempted to change it to "enable_hw_scan" instead...
>>>       
>> Give the advantages, I'd like to use it if we can fix the bug (I haven't
>> seen what the bug is myself). But you are free to change the default
>> value until it is fixed. There is no such problem for 4965, right?
>>     
>
>
> - --
> Filippo Zangheri
>
> GPG key ID: 0x6C1F2F2F
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFIUjROjzxMG2wfLy8RApPjAJ4sUw0x9TcLYOh/YdIxV/hFWeUbCwCfWaLK
> Wk97c4XkgpxvN8RNvzNefJA=
> =Gn9F
> -----END PGP SIGNATURE-----
>
>
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>   

