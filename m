Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44119 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2GXPqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:46:22 -0400
Received: by ghrr11 with SMTP id r11so6789920ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 08:46:21 -0700 (PDT)
Message-ID: <500EC34A.7030300@lwfinger.net> (sfid-20120724_174630_815539_5976A13E)
Date: Tue, 24 Jul 2012 10:46:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com>
In-Reply-To: <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 10:25 AM, Xavier de Almeida wrote:
> great following this thread to make my own compat-wireless:
> http://blog.securism.com/2009/01/how-to-cutting-edge-wireless-drivers-in-ubuntu/
>
>
> I hope it's accurate

A quick read shows that they have you pulling the entire wireless-testing tree. 
If you do that, then build that kernel and skip compat-wireless. I think the 
URLs have changed since 2009.

If you have your kernel headers installed, and /lib/modules/`uname -r`/build is 
a link to a directory containing directory include/ with those headers, then you 
can built the compat-wireless package.

Larry





