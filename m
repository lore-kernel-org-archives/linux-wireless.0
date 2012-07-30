Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43892 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3V13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 17:27:29 -0400
Received: by ghrr11 with SMTP id r11so5399443ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 14:27:28 -0700 (PDT)
Message-ID: <5016FC3D.8070408@lwfinger.net> (sfid-20120730_232737_908250_87D994B1)
Date: Mon, 30 Jul 2012 16:27:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> <50140463.3080209@lwfinger.net> <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5015A2DB.50106@lwfinger.net> <1343671587.79175.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5016E5CD.2090100@lwfinger.net> <1343678594.9254.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343679436.38076.YahooMailNeo@web28902.mail.ir2.yahoo.com>
In-Reply-To: <1343679436.38076.YahooMailNeo@web28902.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2012 03:17 PM, Xavier de Almeida wrote:
> I did some ADSL test connected through the wireless.
> When I use my router wifi (bcm57xx) I get 20 times a better download than with the rtl8188 chip. The upload is exactly the same and both are connected with g.

In my tests, the RTL8192CE has throughput of roughly 20 Mbps when connected to 
an 802.11g network as a station. As 27 is the maximum, 20x is impossible. When 
an 802.11n connection is used, I get about 80 Mbps. You need to give a detailed 
setup, and actual numbers, preferably when connected to a local host, not 
something on the Internet.

> Signal is lower but still good at 4/5 meters from the barebone.
>
> Any potential reason?

Driver rtl8192ce is optimized to work as a station. If you want better 
performance as an AP, you will have to sort that out yourself.

Larry

