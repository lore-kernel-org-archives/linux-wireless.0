Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:2157 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYFNKAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 06:00:55 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2478329fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 03:00:51 -0700 (PDT)
Message-ID: <485396CE.2070704@gmail.com> (sfid-20080614_120058_950573_E9557DE0)
Date: Sat, 14 Jun 2008 13:00:46 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: =?ISO-8859-1?Q?Tor_H=E5kon_Haugen?= <tor.hakon.haugen@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	 <1213241315.7814.696.camel@debian.sh.intel.com>	 <20080612135936.GA5031@tuxdriver.com>	 <1213342523.7814.865.camel@debian.sh.intel.com>	 <20080613130310.GA5333@tuxdriver.com> <48528B63.5030403@gmail.com>	 <48528CF0.8050204@gmail.com> <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
In-Reply-To: <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Fri, Jun 13, 2008 at 6:06 PM, Maxim Levitsky <maximlevitsky@gmail.=
com> wrote:
>> Tor H=E5kon Haugen wrote:
>>> John W. Linville wrote:
>>>> On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
>>>>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>>>>>> Honestly I'm tempted to change it to "enable_hw_scan" instead...
>>>>> Give the advantages, I'd like to use it if we can fix the bug (I =
haven't
>>>>> seen what the bug is myself). But you are free to change the defa=
ult
>>>>> value until it is fixed. There is no such problem for 4965, right=
?
>>>> AFAICT only the 3945 seems to need it.
>>>>
>>> I can confirm that this also applies to 4965 as a friend of mine ha=
s
>>> this card. According to him the card works a lot better with the
>>> parameters "swcrypto=3D1" and "disable_hw_scan=3D1".
>> Just to make it clear,
>> iwl3945 doesn't work at all without disable_hw_scan=3D1 here.
>> The driver just shuts down thee card since it detects microcode erro=
r.
>>
>=20
> It looks like this is all caused by the big rate, band patch. Looks
> like A band scan channels are not configured correctly for the
> scanning. This crashes the firmware.
>=20
> Tomas
Any patches to fix this are welcome.

Best regards,
	Maxim Levitsky
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
