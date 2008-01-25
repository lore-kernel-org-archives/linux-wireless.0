Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:43629 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbYAYIff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 03:35:35 -0500
Message-ID: <47999F51.6040403@scherping.de> (sfid-20080125_083541_512060_D7D222B8)
Date: Fri, 25 Jan 2008 09:35:29 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: hong zhang <henryzhang62@yahoo.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: does any wifi driver supports 802.11n for access point?
References: <785147.24297.qm@web57907.mail.re3.yahoo.com>
In-Reply-To: <785147.24297.qm@web57907.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hong zhang schrieb:
> How about iwl4965?
> is iwl4965 based on which wifi chip?

iwl4965 is for Intel=AE Wireless WiFi Link 4965AGN (http://www.intel.co=
m/network/connectivity/products/wireless/wireless_n/overview.htm) and w=
orks quite well. I have tested version 1.1.17 of the driver successfull=
y connecting to a Atheros-based 11n access point by D-Link and reached =
about 80 MBit/s UDP netto.

Richard
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
