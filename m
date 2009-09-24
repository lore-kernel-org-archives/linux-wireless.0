Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:46340 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZIXH5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 03:57:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at will
Date: Thu, 24 Sep 2009 09:56:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909211259.45431.hs4233@mail.mn-solutions.de> <200909221123.36953.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909221123.36953.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909240956.57344.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> script -c "./wpa_supplicant -i eth1 -D wext -t -c mnfunk.conf -d" 1
> Wait till "ping" works
Ctrl-C
> script -c "./wpa_supplicant -i eth1 -D wext -t -c mnfunk.conf -d" 2

I cannot reproduce this anymore, dunny why.

-- 
http://www.holgerschurig.de
