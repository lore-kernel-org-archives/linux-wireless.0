Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53502 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2G0Lvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:51:31 -0400
Received: by yhmm54 with SMTP id m54so3051528yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 04:51:31 -0700 (PDT)
Message-ID: <501280BF.4070409@lwfinger.net> (sfid-20120727_135135_558447_339005E3)
Date: Fri, 27 Jul 2012 06:51:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com>
In-Reply-To: <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2012 01:34 AM, Xavier de Almeida wrote:
> Hi Larry,
>
> I am using hostapd v0.7.3 but I did not install the bleeding-edge compat-wireless drivers.
>
> What I noticed is that your script refers to module se while I have a ce. (I am not sure if this can impact or explain the differences between your setup and mine).
>
> When I download the drivers from http://wireless.kernel.org/en/users/Download#Where_to_download_bleeding_edge, I got this file "compat-wireless-2.6.tar.bz2" which contains maybe a too old version compat-wireless-2012-05-10.
>
> Should I install this version?
> If I install kernel 3.5.0, will I still need to install the compat-wireless drivers?

The SE was in the ESSID. Do you think that matters?? The chip I used was an 
RTL8188CE, the same as yours.

You need to install the bleeding-edge compat wireless from 
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2. 
That sounds like the version you got.

Installing kernel 3.5 0 will get older drivers than compat-wireless. That is the 
way that kernel development works. The ones in 3.5.0 should be OK, but 
installing compat would be easier than generating a 3.5 kernel.

Larry



