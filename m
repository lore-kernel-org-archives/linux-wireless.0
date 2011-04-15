Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57929 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1DOTwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 15:52:02 -0400
MIME-Version: 1.0
In-Reply-To: <1302896541.30441.33.camel@dev.znau.edu.ua>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<1302781431.21145.6.camel@dev.znau.edu.ua>
	<BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	<4DA6E9BD.3090404@hauke-m.de>
	<BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
	<1302786900.21965.52.camel@dev.znau.edu.ua>
	<BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
	<1302892585.30441.12.camel@dev.znau.edu.ua>
	<BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
	<1302896541.30441.33.camel@dev.znau.edu.ua>
Date: Fri, 15 Apr 2011 21:52:01 +0200
Message-ID: <BANLkTinPVaYC14Y=m5iu7GYodkRb6uTuPw@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Andy Botting <andy@andybotting.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 kwietnia 2011 21:42 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
> So, we could start with introducing virtual "ocp" bus (which could be of
> some use for other vendors utilising ocp model) with additional
> library/module for broadcom-specific extensions (accounting for
> buscommon/buscore/etc.).

I think we over-complicate that.


> On other hand just broadcom-specific bus looks like good alternative too
> but here I just fail to decide on relevant naming.

Just bcmamba / bcmaxi?

-- 
Rafał
