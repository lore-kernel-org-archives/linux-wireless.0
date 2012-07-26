Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32808 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2GZKxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 06:53:45 -0400
Received: by yhmm54 with SMTP id m54so1779481yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 03:53:44 -0700 (PDT)
Message-ID: <501121B5.4010305@lwfinger.net> (sfid-20120726_125349_081261_51C3F063)
Date: Thu, 26 Jul 2012 05:53:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com>
In-Reply-To: <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2012 04:58 AM, Xavier de Almeida wrote:
> Thanks Larry for your inputs.
>
>  From this thread it looks like it's not a given piece of work to get the RTL8188CE stable.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/902557
>
> Anyway I have started to compile the 3.4.6 kernel see how it goes. I hope I don't need to add the compat-wireless drivers on top?
>
> Will report in more than 4h after the make is completed :D

That Ubuntu report is for kernel 3.2. As I said before, we are making progress!!!!!

See https://bugzilla.redhat.com/show_bug.cgi?id=797709 for a better example.

I think 3.4.6 will be OK, but if you need compat-wireless, it will work OK there.

Larry

