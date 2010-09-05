Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server3.hostdango.com ([67.222.146.219]:44545 "EHLO
	server3.hostdango.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0IEUDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 16:03:01 -0400
Received: from adsl-71-133-204-142.dsl.pltn13.pacbell.net ([71.133.204.142] helo=[10.6.9.2])
	by server3.hostdango.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <krellan@krellan.com>)
	id 1OsKf8-0004MB-5c
	for linux-wireless@vger.kernel.org; Sun, 05 Sep 2010 12:13:58 -0700
Message-ID: <4C83EBF5.1030405@krellan.com>
Date: Sun, 05 Sep 2010 12:13:57 -0700
From: Josh Lehan <krellan@krellan.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Merging vendor's upstream changes into vt6656 driver
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Question about the VIA vt6656 driver, currently in staging.

Reading the comments, I see that it is based on the vendor's 1.19.12
driver, dated 2-Feb-2009.

However, the vendor has released an updated version: 1.20.03, dated
2-Dec-2009.

Here is the vendor's website for their VT6656 Linux open source driver
(sorry about line wraparound, the URL is long):

http://www.viaarena.com/ViaDisplayDrivers.aspx?PageID=1&OSID=25&CatID=2590&SubCatID=176&lang=en-GB

I'm willing to have a go at merging the vendor's differences between
1.19.12 and 1.20.03, into the Linux driver.

Is anybody else currently working on this project?  I don't want to
duplicate work, if somebody's already doing this.

Thanks!

Josh
