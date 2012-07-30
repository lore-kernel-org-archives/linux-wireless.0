Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:60064 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2G3VBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 17:01:19 -0400
Message-ID: <5016F59E.9070101@01019freenet.de> (sfid-20120730_230123_131075_6B0A129B)
Date: Mon, 30 Jul 2012 22:59:10 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "Ch. Hanisch" <ch-hanisch@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
References: <5016F03F.1020508@t-online.de>
In-Reply-To: <5016F03F.1020508@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ch. Hanisch wrote:
> Hello,
> 
> on an DELL XPS L702x under Ubuntu 12.04LTS (64Bit) the WLAN is not working.
> The network manager show the message
> "device is no ready"

- Please provide a lspci -vn of the device not running, too.

- Did you try actual compat-wireless from
http://linuxwireless.org/download/compat-wireless-2.6/
Does it show the same behaviour?


Thanks,
kind regards,
Andreas
