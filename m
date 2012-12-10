Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2LJMqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 07:46:35 -0500
Message-ID: <1355143613.9857.20.camel@jlt4.sipsolutions.net> (sfid-20121210_134638_996605_B21C9E50)
Subject: rtl8192cu problem - Re: Wireless network problem with Access Point
 selection using ifup
From: Johannes Berg <johannes@sipsolutions.net>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 10 Dec 2012 13:46:53 +0100
In-Reply-To: <50C5CEF4.1070907@cfl.rr.com>
References: <50C0A743.3000305@compro.net>
	     (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>
	    <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net>
	   <1354913688.9124.2.camel@jlt4.sipsolutions.net>
	   <50C25A4B.8030302@compro.net> <50C5B65F.4040104@cfl.rr.com>
	  <1355135199.9857.11.camel@jlt4.sipsolutions.net>
	  <50C5C321.1090501@cfl.rr.com>
	 <1355138959.9857.13.camel@jlt4.sipsolutions.net>
	 <50C5CEF4.1070907@cfl.rr.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 07:00 -0500, Mark Hounschell wrote:

> Should I file and bug report and/or contact the author?

Larry, the issue seems to be that rtl8192cu doesn't scan after having
disconnected at least once, and maybe doesn't report any/good signal
strength values.

johannes

