Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60011 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab0CVWZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 18:25:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Mon, 22 Mar 2010 23:25:35 +0100
Cc: Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu> <4BA7E79C.9070100@lwfinger.net>
In-Reply-To: <4BA7E79C.9070100@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003222325.35994.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 22:56:44 Larry Finger wrote:
> Does anyone have any suggestions on what characteristic could be used to
> generate a unique MAC address for a box in a udev rule?

/dev/urandom

Yeah, there's the chance of clashes. In practice there won't be any clashes,
however. If you think there's a real risk, you should start playing
the lottery tomorrow. You'll immediately win a million dollars so you don't have
to worry about those questions anymore. ;)

In fact, I think the risk for mac clashes is not really reduced by generating the mac
address from serial numbers, whatever, etc...

-- 
Greetings, Michael.
