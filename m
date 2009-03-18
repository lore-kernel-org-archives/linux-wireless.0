Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15580 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbZCRUi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 16:38:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 13:38:55 -0700
From: David Quan <David.Quan@Atheros.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Date: Wed, 18 Mar 2009 13:38:53 -0700
Subject: RE: ids missing in ath5k ?
Message-ID: <15B47C78534E094AA9A41F58FB8D74F3EB52CAF91C@SC1EXMB-MBCL.global.atheros.com> (sfid-20090318_213900_834013_7DA2F2DA)
References: <49BC0DBE.90209@gmail.com> <49BC6C21.6020807@gmail.com>
 <49BC7117.1010107@gmail.com>
 <b6c5339f0903171418h6534a5a8w1ef8354f9571657a@mail.gmail.com>
 <20090317213639.GF6061@tesla> <49C15A98.7000005@gmail.com>
In-Reply-To: <49C15A98.7000005@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This chips is long been EOL and no sw supports this chip.
not in windows.


-----Original Message-----
From: Xose Vazquez Perez [mailto:xose.vazquez@gmail.com]
Sent: Wednesday, March 18, 2009 12:33 PM
Cc: Bob Copeland; linux-wireless; Luis Rodriguez; David Quan
Subject: Re: ids missing in ath5k ?

Luis R. Rodriguez wrote:

> ACK on FF1A -- 802.11abg, NACK on the others, we don't at least have
> them in our own windows driver INF file.

0x168C, 0x0020 is:

ZyXEL M-302 Wireless G+ SuperSpeed PCI Card: http://www.zyxel.com/web/product_family_detail.php?PC1indexflag=20040520161256&CategoryGroupNo=06EDB83D-54BD-462D-A76B-EF0D3430A2DF&display=7041

driver: ftp://ftp2.zyxel.com/M-302/driver/M-302_2.0.0.zip

inf attached.


regards,
--
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
