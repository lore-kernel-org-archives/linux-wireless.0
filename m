Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45146 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1IUVJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 17:09:53 -0400
Received: by yib18 with SMTP id 18so1442411yib.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 14:09:53 -0700 (PDT)
Message-ID: <4E7A529E.1040808@lwfinger.net> (sfid-20110921_230957_818002_D770D2B6)
Date: Wed, 21 Sep 2011 16:09:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: george0505@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com>
In-Reply-To: <4E7A4BFB.2080102@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 03:41 PM, Chiefdome wrote:
> On 09/21/2011 10:39 PM, Chiefdome wrote:
>> On 09/21/2011 10:37 PM, Larry Finger wrote:
>>> On 09/21/2011 03:28 PM, Chiefdome wrote:
>>>> The AP showen above is configured as you say as an 802.11bgn device. The
>>>> wireless connection is controlled by wicd.
>>>
>>> I just reviewed our entire correspondence on this issue. I could not find
>>> where you specified the make and model of the AP.
>>>
>>> I have never used wicd, but several people on the openSUSE forums abandoned
>>> it because it was buggy. Are you sure it is not the problem?
>>>
>>> Larry
>>>
>> I also have a built-in iwlagn-wireless-card wicd is seriously not the problem.
>> What would you suggest to use to make a wireless connection from the gui?
>> With network-manager I have the same problems.
>>
>> Chiefdome
>
> Sorry I forgot to say what the AP is, it is a FritzBox 7270 v2.

It seems that we are converging on an incompatibility between that FritzBox 7270 
and rtl8192cu as a problem.

*George* Do you have one in your Lab? As the price on EBay is $275 US, I'm not 
very interested in getting one.

*Chiefdome* Would it be possible for you to run Wireshark on some other machine 
and send us the capture file for the attempt to connect? When you use WPA-TKIP 
encryption, does it work? I would also appreciate your using 'git log' and 
verify that commits bac2555c6d863871329 and 3401dc6eba788ebc7c is present in 
your source.

Larry
