Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49101 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3A3KJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 05:09:36 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so587478eab.6
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 02:09:35 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
Date: Wed, 30 Jan 2013 11:09:32 +0100
Message-ID: <15452550.1ttGSZchYI@sylvesterjr.pats.ua.ac.be> (sfid-20130130_110940_457353_EA131CBC)
In-Reply-To: <1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be>
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be> <87txq1crst.fsf@purkki.adurom.net> <1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have had a look at the source code of the driver and as far as I can see, 
the driver just never looks at the software configuration when enabling 
promiscuous mode and thus does not pass this information to the 
system, which explains why packets are never captured in promiscuous 
mode, even when the user configures the interface that way.

After that I got a bit lost, so is there anyone who can help me fixing this 
bug?

Best regards,
Erwin

