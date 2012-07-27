Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.ird.yahoo.com ([77.238.189.221]:29147 "HELO
	nm20-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751044Ab2G0NJm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 09:09:42 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net>
Message-ID: <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> (sfid-20120727_150947_068014_6F5A456F)
Date: Fri, 27 Jul 2012 14:09:41 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <501280BF.4070409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I have download the file from your link which provides a directory called: "compat-wireless-2012-05-10". I was using one called "compat-wireless-2012-07-03".

FYI I already compiled the 3.5 kernel but as you recommend I keep using the 3.4.6 for now as it will not necessary bring something new around the rtl8188ce wifi driver.

FYI there should be something wrong in the README as if I do:
root@HTPC:/home/xabix/tmp/compat-wireless-2012-05-10# ./scripts/driver-select rtl8192ce
Processing new driver-select request...
Backing up makefile: Makefile.bk
Unsupported driver

I ve got the Unsupported driver message

Anyway I am compilling them all based on the link you suggested: compat-wireless-2012-05-10

Will report when done

merci
