Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ird.yahoo.com ([77.238.189.203]:37026 "HELO
	nm8-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753363Ab2G2T5Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 15:57:16 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> <50140463.3080209@lwfinger.net>
Message-ID: <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com> (sfid-20120729_215753_395216_6DB38D9D)
Date: Sun, 29 Jul 2012 20:57:14 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <50140463.3080209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I run mine, when I test AP mode, without any options.

> 
> I'm glad you got it working. Now you know why I recommend spending 40 euro 
> for 
> an AP rather than trying to use a 600 euro computer for that purpose. BTW, I own 
> 
> 4 AP/routers.
> 
> Larry
> 

My goal was to have a low power server that runs 24h for wireless, domotic, ... but I didn't find how to increase the signal and remove the power mgt.

Have you had to add parameters in your rtl8192ce.conf file in modprobe?

I found this device in my garage :) which is known to be working well so I may try it just to compare the signal strengths between both
rtl8187 Alfa AWUS036H 0x0bda 0x8187
 

Again I would like to thank you again for all your reactive support in order to help me making my on-board pci wifi card working. At least I can now make a choice depending on the signal length.

FYI I did find that the BW was quote low with the rtl8188ce AP. Did you notice the same issue?

MERCI
