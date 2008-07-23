Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agave.telenet-ops.be ([195.130.137.77]:50901 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGWL35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 07:29:57 -0400
Message-ID: <48871632.3010205@tvcablenet.be> (sfid-20080723_133001_713055_C86444A0)
Date: Wed, 23 Jul 2008 13:29:54 +0200
From: =?ISO-8859-15?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
References: <bug-11144-10286@http.bugzilla.kernel.org/>	<20080722034850.dbbc5566.akpm@linux-foundation.org>	<4886E49D.6010700@tvcablenet.be> <20080723010522.389a948f.akpm@linux-foundation.org> <4886F727.6010301@tvcablenet.be> <48870425.50908@trash.net>
In-Reply-To: <48870425.50908@trash.net>
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patrick McHardy a =E9crit :
> Fran=E7ois Valenduc wrote:
>> OK, thanks for the explanation. But do you have more ideas about the=
=20
>> problem ?
>
> I tested myself using dhcpcd 3.2.3 on an ethernet device and it
> works fine, so this appears to be driver related.
>
>

I also noticed that DHCP works without problem with my ethernet card=20
(using the sky2 driver), so there seems to be a problem or conflict wit=
h=20
the iwl4965 driver. However, if I use dhclient instead of dhcpcd, I can=
=20
get an IP adress with DHCP and the DNS servers are correctly written in=
=20
/etc/resolv.conf. Unfortunately, name resolution doesn't work, even if =
I=20
can ping the DNS server.

=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
