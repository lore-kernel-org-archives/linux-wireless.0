Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59053 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0CWLnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 07:43:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Tue, 23 Mar 2010 12:43:12 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <4BA7E79C.9070100@lwfinger.net> <201003230955.39871.florian@openwrt.org>
In-Reply-To: <201003230955.39871.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003231243.13117.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 March 2010 09:55:39 Florian Fainelli wrote:
> Why not use random_ether_addr and only use the digits that you are interested 
> in?

Because it's not constant across reboots.

-- 
Greetings, Michael.
