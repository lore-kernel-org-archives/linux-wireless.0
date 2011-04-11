Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41625 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1DKXWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 19:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
Date: Tue, 12 Apr 2011 01:22:37 +0200
Message-ID: <BANLkTimgeKJZ+pyF8wOpxMtt2KSiD6=eCA@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
> V3.1: Include forgotten changes (pr_* and include related)
>    Explain why we dare to implement empty release function

I forgot to include TODO in commit message. This is still not ready
for mainline.

TODO:
- Documentation/ABI/README entry for new sysfs files

(Greg: earlier in V3 I put this part of TODO in file, sorry for confusing).

I hope rest of tasks from *file* TODO can be done after getting this mainline.

-- 
Rafał
