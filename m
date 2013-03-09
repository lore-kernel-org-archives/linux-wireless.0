Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44213 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3CIM6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 07:58:24 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so2049906obc.27
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 04:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
Date: Sat, 9 Mar 2013 13:58:23 +0100
Message-ID: <CACna6rwxMygCwLyya_c9ipA-pEUJzGmWchAY=GNLfKegwy_XPw@mail.gmail.com> (sfid-20130309_135827_063156_3B24DF42)
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/7 Rafał Miłecki <zajec5@gmail.com>:
> After spotting a lot of N-PHY-similar functions in
> BCM4331 dump of MMIO ops - split into names parts
> I was able to finally improve HT-PHY code.
>
> It now sets TX basically, I can finally talk with devices that are few
> meters away, not just few centimetres. It's a little patch bomb, sorry
> for that, but I wasn't sure if my code is correct until it was complete
> and started working.
>
> Rafał Miłecki (13):
>   b43: HT-PHY: rename AFE defines
>   b43: HT-PHY: add classifier control function
>   b43: HT-PHY: move TX fix to the separated function
>   b43: HT-PHY: implement spurious tone avoidance
>   b43: HT-PHY: implement MAC reclocking
>   b43: HT-PHY: implement CCA reset
>   b43: HT-PHY: implement PA override
>   b43: HT-PHY: implement controlling TX power control
>   b43: HT-PHY: implement stopping sample tone playback
>   b43: HT-PHY: implement playing sample tone
>   b43: HT-PHY: implement RSSI polling
>   b43: HT-PHY: setup TX power control
>   b43: HT-PHY: enable basic TX power setup

I've finished sending V2 of some patches, arrays are now converted to
static const where possible.

I've tried applying this 3 times and Hauke confirmed is applies
cleanly, so I hope it's fine now.

-- 
Rafał
