Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ird.yahoo.com ([77.238.189.214]:42189 "HELO
	nm17-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753674Ab2GXPZX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:25:23 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net>
Message-ID: <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> (sfid-20120724_172527_629359_510BCE3F)
Date: Tue, 24 Jul 2012 16:25:22 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <500EBA0C.106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

great following this thread to make my own compat-wireless:
http://blog.securism.com/2009/01/how-to-cutting-edge-wireless-drivers-in-ubuntu/


I hope it's accurate

Merci



>________________________________
> De : Larry Finger <Larry.Finger@lwfinger.net>
>À : Xavier de Almeida <xavierdealmeida@yahoo.fr> 
>Cc : "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org> 
>Envoyé le : Mardi 24 juillet 2012 17h06
>Objet : Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
> 
>On 07/24/2012 08:56 AM, Xavier de Almeida wrote:
>> Thanks Larry for your help.
>> I tried 3.4.6 and 3.5.0 Quantal kernels but they didn't boot with my i8042 keyboard chip.
>>
>> So I have installed 3.2.23-030223 and it now starts OK.
>>
>> FYI here is the new log (I ll have to investigate why the auth between the endpoint and the hotspot doesn't work)
>>
>> MERCI
>> XabiX
>
>Yes, we do make progress. Kernel 3.2.23 has the bug fixes backported from later 
>kernels, but there are additional changes that cannot be implemented as they are 
>too intrusive. You may still need to incorporate compat-wireless.
>
>Larry
>
>
>
>
>
> 
