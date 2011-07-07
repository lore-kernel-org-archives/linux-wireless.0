Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52868 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1GGAkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 20:40:14 -0400
Received: by pzk9 with SMTP id 9so389326pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 17:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110707002034.GA17885@broadcom.com>
References: <20110707002034.GA17885@broadcom.com>
Date: Thu, 7 Jul 2011 02:40:13 +0200
Message-ID: <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com> (sfid-20110707_024018_036802_07AD5E6A)
Subject: Re: [RFC] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: linville@tuxdriver.com, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Zhenhui Lin <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/7 Henry Ptasinski <henryp@broadcom.com>:
> With the latest series of cleanup patches merged in by Greg KH, I'd like to now
> propose moving brcm80211 out of staging and into mainline.
>
> Since brcm80211 in staging-next has about ~250 patches that areen't in
> wireless-testing yet, I've put together a patch to add a copy of the current
> sources from staging-next into wireless-testing:drivers/net/wireless/brcm80211.
>
> The patch is somewhat large, so I've posted the patch at:
>
>        http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
>
> Only the necessary Kconfig and Makefile adjustments have been made (the sources
> are unchanged from what's currently in staging-next).

Short question, without commenting on brcm80211 code yet:

Why should we want 2 mainline drivers for the same hardware?

-- 
Rafał
