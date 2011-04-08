Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37274 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1DHV6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 17:58:17 -0400
Subject: Re: [PATCH][2.6.39?] b43: trivial: update module info about
 firmware
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1302267632-2326-1-git-send-email-zajec5@gmail.com> (sfid-20110408_082321_349809_A49377CD)
References: <1302267632-2326-1-git-send-email-zajec5@gmail.com>
	 (sfid-20110408_082321_349809_A49377CD)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 23:58:10 +0200
Message-ID: <1302299890.28673.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 15:00 +0200, Rafał Miłecki wrote: 
> We do not use ucode9,

Well, but we should.
There are only minor differences between r5 and r9 firmware.
r9 basically is a r5 firmware with workarounds added that are
needed for r9 devices.

So I think we should start using r9 instead of removing it here.

-- 
Greetings Michael.

