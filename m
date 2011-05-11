Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3.bullet.mail.bf1.yahoo.com ([98.139.212.162]:31715 "HELO
	nm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757348Ab1EKQZK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:25:10 -0400
Message-ID: <13602.31426.qm@web161615.mail.bf1.yahoo.com> (sfid-20110511_182522_013835_A1A01E66)
Date: Wed, 11 May 2011 09:25:08 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [gsimmons@gsimmons.org: Bug#596626: Please support Linksys WUSB600N v2 WiFi USB stick]
To: Ivo van Doorn <IvDoorn@gmail.com>, maximilian attems <max@stro.at>
Cc: linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>, 596626@bugs.debian.org
In-Reply-To: <20110511142330.GF4387@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As mentioned by Jan, the device contains a RT3572
> chipset.  Its entry
> could moved into the section for known RT35XX devices (i.e.
> "#ifdef
> CONFIG_RT2800USB_RT35XX") as an alternative.
> 
> Geoff

This has already been done: http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commitdiff;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
