Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab3LERkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 12:40:33 -0500
Message-ID: <1386265226.4182.20.camel@jlt4.sipsolutions.net> (sfid-20131205_184042_226603_61AECF19)
Subject: Re: Using wmediumd in kernel 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 18:40:26 +0100
In-Reply-To: <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com>
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>
			 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>
		 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>
	 <1386260744.4182.18.camel@jlt4.sipsolutions.net>
	 <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 16:42 +0000, Dani Camps wrote:
> ping -I mesh0 192.168.77.11

Works fine for me. Maybe you should try a later backports version, e.g.
3.12? I don't remember fixing anything, but I don't see any issues
either.

johannes

