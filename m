Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYGWKM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 06:12:57 -0400
Message-ID: <48870425.50908@trash.net> (sfid-20080723_121301_632909_87FCF276)
Date: Wed, 23 Jul 2008 12:12:53 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
References: <bug-11144-10286@http.bugzilla.kernel.org/>	<20080722034850.dbbc5566.akpm@linux-foundation.org>	<4886E49D.6010700@tvcablenet.be> <20080723010522.389a948f.akpm@linux-foundation.org> <4886F727.6010301@tvcablenet.be>
In-Reply-To: <4886F727.6010301@tvcablenet.be>
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46ran=E7ois Valenduc wrote:
> OK, thanks for the explanation. But do you have more ideas about the=20
> problem ?

I tested myself using dhcpcd 3.2.3 on an ethernet device and it
works fine, so this appears to be driver related.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
