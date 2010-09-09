Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nikosapi.org ([209.123.162.110]:52669 "EHLO nikosapi.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab0IIDOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 23:14:19 -0400
Received: from 69-196-138-241.dsl.teksavvy.com ([69.196.138.241] helo=[192.168.0.109])
	by nikosapi.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <nikosapi@nikosapi.org>)
	id 1OtXDf-0000YQ-4J
	for linux-wireless@vger.kernel.org; Wed, 08 Sep 2010 22:50:35 -0400
Subject: Re: ath9k: freeze when putting interface up
From: Nick Nobody <me@nikosapi.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 22:50:30 -0400
Message-ID: <1284000630.2060.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm experiencing the exact same thing (with the same hardware). I'm
using 2.6.35.4 with compat-wireless-2010-08-21.

Running Bjørnar Hansen's test, my system will freeze around 20. Using
the version of ath9k that comes with 2.6.35.4 is impossible because the
system would freeze on the first "ifconfig wlan0 up". My wireless
connection is also a lot less stable compared to how it used to be with
a 2.6.32 kernel on Fedora 12 (I'm using Arch now).

I'll try to help in whatever way I can, just let me know what you need.

nick

