Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm4.bullet.mail.ird.yahoo.com ([77.238.189.61]:37808 "HELO
	nm4.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755255Ab2GXRG6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 13:06:58 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com>
Message-ID: <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> (sfid-20120724_190702_305381_79EF7996)
Date: Tue, 24 Jul 2012 18:06:56 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
In-Reply-To: <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry and the team,

couldn't install my compiled (make + checkinstall) package.

sudo dpkg -i compat-wireless-2012-07_03-1_i386.deb 
(Reading database ... 214923 files and directories currently installed.)
Unpacking compat-wireless-2012-07 (from compat-wireless-2012-07_03-1_i386.deb) ...
dpkg: error processing compat-wireless-2012-07_03-1_i386.deb (--install):
 trying to overwrite '/bin/ntfs-3g', which is also in package ntfs-3g 1:2012.1.15AR.1-1ubuntu1
dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
Errors were encountered while processing:
 compat-wireless-2012-07_03-1_i386.deb

Should I just to a make install instead?

Thanks
XabiX


----- Mail transféré -----
>De : Xavier de Almeida <xavierdealmeida@yahoo.fr>
>À : Larry Finger <Larry.Finger@lwfinger.net> 
>Cc : "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org> 
>Envoyé le : Mardi 24 juillet 2012 17h25
>Objet : Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
> 
>great following this thread to make my own compat-wireless:
>http://blog.securism.com/2009/01/how-to-cutting-edge-wireless-drivers-in-ubuntu/
>
>
>I hope it's accurate
>
>Merci
>
>
>
>>________________________________
>> De : Larry Finger <Larry.Finger@lwfinger.net>
>>À : Xavier de Almeida <xavierdealmeida@yahoo.fr> 
>>Cc : "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org> 
>>Envoyé le : Mardi 24 juillet 2012 17h06
>>Objet : Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
>> 
>>On 07/24/2012 08:56 AM, Xavier de Almeida wrote:
>>> Thanks Larry for your help.
>>> I tried 3.4.6 and 3.5.0 Quantal kernels but they didn't boot with my i8042 keyboard chip.
>>>
>>> So I have installed 3.2.23-030223 and it now starts OK.
>>>
>>> FYI here is the new log (I ll have to investigate why the auth between the endpoint and the hotspot doesn't work)
>>>
>>> MERCI
>>> XabiX
>>
>>Yes, we do make progress. Kernel 3.2.23 has the bug fixes backported from later 
>>kernels, but there are additional changes that cannot be implemented as they are 
>>too intrusive. You may still need to incorporate compat-wireless.
>>
>>Larry
>>
>>
>>
>>
>>
>> 
>
>
>
