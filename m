Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57913.mail.re3.yahoo.com ([68.142.236.106]:47785 "HELO
	web57913.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755069AbYAYP6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 10:58:11 -0500
Date: Fri, 25 Jan 2008 07:58:06 -0800 (PST)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: does any wifi driver supports 802.11n for access point?
To: Richard Scherping <richard@scherping.de>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <47999F51.6040403@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <596875.96052.qm@web57913.mail.re3.yahoo.com> (sfid-20080125_155815_358486_72DDECAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard,

Because current open source mdwifi and mac80211 do not
support atheros 802.11n chip yet.
Does Atheros provide 802.11n driver for its 802.11n
chip? Where does Dlink get 802.11n atheros driver for
its aceess point products?

----henry

--- Richard Scherping <richard@scherping.de> wrote:

> hong zhang schrieb:
> > How about iwl4965?
> > is iwl4965 based on which wifi chip?
>=20
> iwl4965 is for Intel=EF=BF=BD Wireless WiFi Link 4965AGN
>
(http://www.intel.com/network/connectivity/products/wireless/wireless_n=
/overview.htm)
> and works quite well. I have tested version 1.1.17
> of the driver successfully connecting to a
> Atheros-based 11n access point by D-Link and reached
> about 80 MBit/s UDP netto.
>=20
> Richard
>=20



      _________________________________________________________________=
___________________
Looking for last minute shopping deals? =20
=46ind them fast with Yahoo! Search.  http://tools.search.yahoo.com/new=
search/category.php?category=3Dshopping
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
