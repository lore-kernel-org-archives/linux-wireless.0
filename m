Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1DFUms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 16:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	<op.vti9ote53ri7v4@arend-laptop>
	<BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
Date: Wed, 6 Apr 2011 22:42:47 +0200
Message-ID: <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/6 Rafał Miłecki <zajec5@gmail.com>:
> If we want to have two drivers working on two (different) cores
> simultaneously, we will have to add trivial mutex to group core
> switching with core operation (read/write).

With a little of work we could avoid switching and mutexes on no-host
boards. MMIO is not limited to one core at once in such a case.

-- 
Rafał
