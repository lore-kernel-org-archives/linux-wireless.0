Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33402
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXGAWQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2007 18:16:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw-mac80211: basic regulatory domain support
Date: Mon, 2 Jul 2007 00:15:32 +0200
Cc: Joerg Mayer <jmayer@loplof.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org
References: <20070701163907.39B6B7B409F@zog.reactivated.net> <20070701203238.GE8218@thot.informatik.uni-kl.de> <20070701213515.GA6829@deine-taler.de>
In-Reply-To: <20070701213515.GA6829@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707020015.32480.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 01 July 2007 23:35:15 Ulrich Kunitz wrote:
> this is not an easy task, because ZD1211 devices have
> numerous different constructions affecting the antenna forms and
> sizes and a greater number of different RF chips. BTW we have no
> documentation about the registers controlling the output power.
> We are currently using the register parameters the vendor driver
> is using. If somebody could provide ongoing measurements, that
> would give us the data points to work on the issue.

Which registers do control power and where are they written?

-- 
Greetings Michael.
