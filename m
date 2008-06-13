Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:47208 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYFMPJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 11:09:59 -0400
Received: by py-out-1112.google.com with SMTP id p76so1843761pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 08:09:58 -0700 (PDT)
Message-ID: <48528DC1.9050806@gmail.com> (sfid-20080613_171003_192838_C9ABF83F)
Date: Fri, 13 Jun 2008 17:09:53 +0200
From: =?ISO-8859-1?Q?Tor_H=E5kon_Haugen?= <tor.hakon.haugen@gmail.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with	disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	<1213241315.7814.696.camel@debian.sh.intel.com>	<20080612135936.GA5031@tuxdriver.com>	<1213342523.7814.865.camel@debian.sh.intel.com>	<20080613130310.GA5333@tuxdriver.com> <48528B63.5030403@gmail.com> <48528CF0.8050204@gmail.com>
In-Reply-To: <48528CF0.8050204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Maxim Levitsky wrote:
> Tor H=E5kon Haugen wrote:
>>
>> John W. Linville wrote:
>>> On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
>>>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>>>>> Honestly I'm tempted to change it to "enable_hw_scan" instead...
>>>> Give the advantages, I'd like to use it if we can fix the bug (I=20
>>>> haven't
>>>> seen what the bug is myself). But you are free to change the defau=
lt
>>>> value until it is fixed. There is no such problem for 4965, right?
>>> AFAICT only the 3945 seems to need it.
>>>
>>
>> I can confirm that this also applies to 4965 as a friend of mine has=
=20
>> this card. According to him the card works a lot better with the=20
>> parameters "swcrypto=3D1" and "disable_hw_scan=3D1".
>=20
> Just to make it clear,
> iwl3945 doesn't work at all without disable_hw_scan=3D1 here.
> The driver just shuts down thee card since it detects microcode error=
=2E
>=20
Ah, Sorry. Disregard my last post then.

  Tor H. Haugen

> Best regards,
>     Maxim Levitsky
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
