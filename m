Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40500 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1LVHHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 02:07:22 -0500
Received: by wgbds13 with SMTP id ds13so11661597wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 23:07:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
	<CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
Date: Thu, 22 Dec 2011 08:07:21 +0100
Message-ID: <CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com> (sfid-20111222_080726_332282_912A0D90)
Subject: Re: bcm4331 firmware installer package
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: lina <lina.lastname@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/22 lina <lina.lastname@gmail.com>:
> I am still a bit confused. (First thanks for the links all of you
> provided, but I have visited those web before).
>
> Here is the thing:
> BCM4331 802.11a/b/g/n fit for
> BCM4331              b/g  HT (r1)
>
> What does the 802.11a for?

Well, your card can operate in 5GHz band (frequencies). But I'm not
 really sure why you ask about this at all.

 If you want to try experimental BCM4331 support you have to:
 1) Install kernel 3.2-rc3 or newer
 or
 2) Install compat wireless

 After that you've do install firmware (check for wiki howto for kernel
 3.2 and newer).

P.S.
Please, don't top post.

-- 
Rafał
