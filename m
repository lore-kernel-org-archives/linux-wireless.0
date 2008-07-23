Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63760 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYGWLbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 07:31:44 -0400
Message-ID: <4887169B.6090102@trash.net> (sfid-20080723_133149_019290_F94389AC)
Date: Wed, 23 Jul 2008 13:31:39 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
References: <bug-11144-10286@http.bugzilla.kernel.org/>	<20080722034850.dbbc5566.akpm@linux-foundation.org>	<4886E49D.6010700@tvcablenet.be> <20080723010522.389a948f.akpm@linux-foundation.org> <4886F727.6010301@tvcablenet.be> <48870425.50908@trash.net> <48871632.3010205@tvcablenet.be>
In-Reply-To: <48871632.3010205@tvcablenet.be>
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46ran=E7ois Valenduc wrote:
> Patrick McHardy a =E9crit :
>> Fran=E7ois Valenduc wrote:
>>> OK, thanks for the explanation. But do you have more ideas about th=
e=20
>>> problem ?
>>
>> I tested myself using dhcpcd 3.2.3 on an ethernet device and it
>> works fine, so this appears to be driver related.
>>
>>
>=20
> I also noticed that DHCP works without problem with my ethernet card=20
> (using the sky2 driver), so there seems to be a problem or conflict w=
ith=20
> the iwl4965 driver. However, if I use dhclient instead of dhcpcd, I c=
an=20
> get an IP adress with DHCP and the DNS servers are correctly written =
in=20
> /etc/resolv.conf. Unfortunately, name resolution doesn't work, even i=
f I=20
> can ping the DNS server.

Interesting. Could you post straces of both commands please?


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
