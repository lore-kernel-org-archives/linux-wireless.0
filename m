Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64993 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2GaFAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 01:00:06 -0400
Received: by wibhm11 with SMTP id hm11so2470870wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 22:00:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5016F59E.9070101@01019freenet.de>
References: <5016F03F.1020508@t-online.de>
	<5016F59E.9070101@01019freenet.de>
Date: Tue, 31 Jul 2012 08:00:05 +0300
Message-ID: <CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com> (sfid-20120731_070014_702462_0D5F6730)
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> on an DELL XPS L702x under Ubuntu 12.04LTS (64Bit) the WLAN is not working.
>> The network manager show the message
>> "device is no ready"
>

How long does the boot take? (From the time you press the power button
until you see the message in the logs).

Can you please add a file (let's say iwlwifi.conf) in
/etc/modprobe.conf with content:
options iwlwifi debug=0xffffffff

And send the output.

Is this a laptop from a big corporate?
