Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([188.94.250.252]:50592 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0I0Kj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:39:56 -0400
Received: from mx51.mymxserver.com (mail5104.internal [172.16.51.4])
	by emita2.mittwald.de (Postfix) with ESMTP id C8FDC230371
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:29:19 +0200 (CEST)
From: Holger Schurig <holgerschurig@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wifi-test: add simple roam test script
Date: Mon, 27 Sep 2010 12:37:50 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"jiajia.zheng@intel.com" <jiajia.zheng@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Paul Stewart <pstew@google.com>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com> <AANLkTimTQ1KP1JDBtSbxiMg-qvSm-Uw7H9EjDyp-WnrJ@mail.gmail.com> <1285265423.3770.359.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285265423.3770.359.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009271237.50950.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It says IP is 0x3, so technically it's not even NULL.

Sounds like someone is using an index into a table of addresses as the address 
instead.

-- 
Homepage: http://www.holgerschurig.de
