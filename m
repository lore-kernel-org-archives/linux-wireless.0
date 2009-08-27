Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:38288 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZH0Gwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 02:52:42 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] rndis_wlan: set cipher suites for cfg80211
Date: Thu, 27 Aug 2009 08:52:04 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20090826125302.25900.98016.stgit@fate.lan> <200908261521.30050.hs4233@mail.mn-solutions.de> <20090826211551.14002pzogxthwfk0@hayate.sektori.org>
In-Reply-To: <20090826211551.14002pzogxthwfk0@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908270852.05023.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2009 20:15:51 Jussi Kivilinna wrote:
> Reason is that rndis_wlan should really check device
> capabilities and set cipher suites
> depending by theim 

Ahh. I was under the impression that chips since two or three 
year always support WEP, WPA and WPA2. And that only the orinoco 
driver (or drivers for similar old chips) need to check the 
firmware/chip to see what is available.

-- 
http://www.holgerschurig.de
