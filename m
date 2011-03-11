Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39388 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CKRz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 12:55:59 -0500
Received: by ywj3 with SMTP id 3so1282027ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 09:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AD827A950317B54A8AF07D45ED639A0FD2DF21C5D4@SJEXCHCCR02.corp.ad.broadcom.com>
References: <AD827A950317B54A8AF07D45ED639A0FD2DF21C5D4@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Fri, 11 Mar 2011 18:55:59 +0100
Message-ID: <AANLkTi=HRSobQBftDExXyTSUgtQr=AwvCNRzbfP2jYrA@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: "Chen, Xianwen" <xianwen.chen@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"CLin@3eti.com" <CLin@3eti.com>,
	Brett Rudley <brudley@broadcom.com>,
	"zajec5@gmail.com" <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

Thanks a lot to all of you! wlan1 showed up after renaming the two files. :D

Henry, there is a typo that it needs to "be bcm43xx-0.fw", not
"bcm43xx--0.fw". Thanks!

Rafal, "dmesg | grep "brcm80211"" really helped locating the issue!
BTW, rebooting is not required after updating PCI information
database. Thanks!

Chaoxing, thanks for the efforts! I really appreciate them too!

Have a nice weekend fellas! ;p

Xianwen

On Fri, Mar 11, 2011 at 6:10 PM, Henry Ptasinski <henryp@broadcom.com> wrote:
> Try:
>
> ln -s bcm43xx-0-610-809-0.fw bcm43xx--0.fw
> ln -s bcm43xx_hdr-0-610-809-0.fw bcm43xx_hdr-0.fw
>
> (Or just rename the files).
>
> We dropped the release numbers from the filenames a while ago. I sent a patch to rename the files in the repo, but I don't think it ever got applied.
>
> - Henry
>
> Henry Ptasinski
> henryp@broadcom.com
>
