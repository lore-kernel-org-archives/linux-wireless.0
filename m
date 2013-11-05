Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3KEWZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 17:25:55 -0500
Date: Wed, 6 Nov 2013 01:25:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
Message-ID: <20131105222537.GF20521@mwanda> (sfid-20131105_232558_437860_B703F7D4)
References: <20131104115111.GM26669@mwanda>
 <52778D30.6030605@hauke-m.de>
 <20131104130728.GA20521@mwanda>
 <5277B7AD.6000309@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5277B7AD.6000309@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's working.  I think it was just a problem with the random old
linux-next kernel I was testing.  Sorry for the noise.

I do think it should be "select BCMA" instead of "depends on BCMA".  Is
there something I have missed?

regards,
dan carpenter
