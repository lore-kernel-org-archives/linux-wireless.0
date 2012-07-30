Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64915 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2G3Tvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 15:51:45 -0400
Received: by gglu4 with SMTP id u4so5256986ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 12:51:45 -0700 (PDT)
Message-ID: <5016E5CD.2090100@lwfinger.net> (sfid-20120730_215148_950870_721961E2)
Date: Mon, 30 Jul 2012 14:51:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> <50140463.3080209@lwfinger.net> <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5015A2DB.50106@lwfinger.net> <1343671587.79175.YahooMailNeo@web28901.mail.ir2.yahoo.com>
In-Reply-To: <1343671587.79175.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2012 01:06 PM, Xavier de Almeida wrote:
>
> (any cheap, good and working USB wifi device which has more power than an embedded chip as the rtl8188 ? it's a shame that we can't add just an antenna vs another wifi hw)

One of the Alfa AWUS036 models has an RTL8188CU chip in it. I think it ends in 
HR. Besides that, there are a number of devices that use the rt2800usb or ath9k 
variants that have external antennas.

I cannot run my RTL8188CE as an internal device as it is not white listed by my 
BIOS, thus I have no idea how well it works with standard laptop antennas.

Larry


