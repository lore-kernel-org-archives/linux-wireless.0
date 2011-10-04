Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43199 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933569Ab1JDU7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 16:59:47 -0400
Received: by eya28 with SMTP id 28so908001eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 13:59:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8B5886.3010103@lwfinger.net>
References: <CA+z-pWFvBfvqY9_km8t3Xbmt=2Pw7eJo8T+SyFp=Lv=d1+ZOPw@mail.gmail.com>
 <4E8B5886.3010103@lwfinger.net>
From: Jamie Kitson <jamie@kitten-x.com>
Date: Tue, 4 Oct 2011 21:59:26 +0100
Message-ID: <CA+z-pWE32ui3nL-NMs5xERiqET6BJ=DkTK7DtkG_pFDt_=YAAg@mail.gmail.com> (sfid-20111004_225950_656350_82096B8D)
Subject: Re: BUG: Soft lockup CPU#0 stuck for 22s! [wpa_supplicant:756]
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Which variant of the RTL8188CE do you have? Use 'lspci -nn' to tell.

03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)

> Does ARCH have an updated kernel later than 3.0?

Looks like I am using the latest core of 3.0.4, there's 3.0.6 in testing:

http://www.archlinux.org/packages/testing/x86_64/linux/

Might that help?

> What version of wpa-supplicant?

wpa_supplicant v0.7.3

> Are you using NetworkManager? If so, what version? Is your desktop KDE,
> Gnome, or something else? If NM, what applet and version?
>
> If not NM, how do you connect?

I use dwm and wpa_supplicant, no manager.

Thanks, Jamie
