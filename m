Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38586 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab1JECz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 22:55:29 -0400
Received: by gyg10 with SMTP id 10so1147567gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 19:55:28 -0700 (PDT)
Message-ID: <4E8BC71C.3010901@lwfinger.net> (sfid-20111005_045533_767634_6DA3749C)
Date: Tue, 04 Oct 2011 21:55:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jamie Kitson <jamie@kitten-x.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: BUG: Soft lockup CPU#0 stuck for 22s! [wpa_supplicant:756]
References: <CA+z-pWFvBfvqY9_km8t3Xbmt=2Pw7eJo8T+SyFp=Lv=d1+ZOPw@mail.gmail.com> <4E8B5886.3010103@lwfinger.net> <CA+z-pWE32ui3nL-NMs5xERiqET6BJ=DkTK7DtkG_pFDt_=YAAg@mail.gmail.com>
In-Reply-To: <CA+z-pWE32ui3nL-NMs5xERiqET6BJ=DkTK7DtkG_pFDt_=YAAg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2011 03:59 PM, Jamie Kitson wrote:
>> Which variant of the RTL8188CE do you have? Use 'lspci -nn' to tell.
>
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
>
>> Does ARCH have an updated kernel later than 3.0?
>
> Looks like I am using the latest core of 3.0.4, there's 3.0.6 in testing:
>
> http://www.archlinux.org/packages/testing/x86_64/linux/
>
> Might that help?

Probably not. I think all the changes in the mainline 3.1-rc8 are in 3.0.4.
>
>> What version of wpa-supplicant?
>
> wpa_supplicant v0.7.3

That is what I use.

>> Are you using NetworkManager? If so, what version? Is your desktop KDE,
>> Gnome, or something else? If NM, what applet and version?
>>
>> If not NM, how do you connect?
>
> I use dwm and wpa_supplicant, no manager.

I know nothing of dwm, but the driver works on my system with both NM and with ifup.

Larry

