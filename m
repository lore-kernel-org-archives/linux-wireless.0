Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3536 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab3KFKFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:05:02 -0500
Message-ID: <527A0F8D.1050409@broadcom.com> (sfid-20131106_110531_768511_2E5CF573)
Date: Wed, 6 Nov 2013 10:44:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
References: <20131104115111.GM26669@mwanda>
 <52778D30.6030605@hauke-m.de> <20131104130728.GA20521@mwanda>
 <5277B7AD.6000309@broadcom.com> <20131105222537.GF20521@mwanda>
In-Reply-To: <20131105222537.GF20521@mwanda>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2013 11:25 PM, Dan Carpenter wrote:
> It's working.  I think it was just a problem with the random old
> linux-next kernel I was testing.  Sorry for the noise.
>
> I do think it should be "select BCMA" instead of "depends on BCMA".  Is
> there something I have missed?

I agree that most users would be unaware that they need BCMA. However, 
the usual problem with 'select' is that the dependencies of the selected 
item are not selected. I believe Kconfig will fire off a warning for it, 
but the aforementioned users may only raise an eyebrow and continue.

If there are Kconfig wizards out there, please feel free to make any 
suggestions.

Regards,
Arend

