Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57134 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab2GZOjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 10:39:55 -0400
Message-ID: <501156B9.6020201@net.t-labs.tu-berlin.de> (sfid-20120726_163959_017240_F7376B1D)
Date: Thu, 26 Jul 2012 16:39:53 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343208990.4463.25.camel@jlt3.sipsolutions.net> <1343220625.4463.31.camel@jlt3.sipsolutions.net> <500FEDDD.206@net.t-labs.tu-berlin.de> <1343244302.3750.44.camel@cumari.coelho.fi> <1343283856.4611.1.camel@jlt3.sipsolutions.net> <50110D8C.3010705@net.t-labs.tu-berlin.de> <1343303858.4477.1.camel@jlt3.sipsolutions.net> <501147D3.2080606@net.t-labs.tu-berlin.de> <87hasu7g8v.fsf@purkki.adurom.net>
In-Reply-To: <87hasu7g8v.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Kalle Valo schrieb:


> 'make allyesconfig' and 'make allmodconfig' are handy to catch problems
> like this. Highly recommended when doing not so simple changes, but be
> prepared for long compile times.
> 


Thx Kalle for that hint ... something like this I was really looking to
find !

Greetings Thomas
