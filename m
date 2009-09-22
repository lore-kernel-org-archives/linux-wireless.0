Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4956 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbZIVLSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 07:18:31 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP and WPA
Date: Tue, 22 Sep 2009 13:17:40 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909221118.04569.hs4233@mail.mn-solutions.de> <200909221258.44921.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909221258.44921.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909221317.40503.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> However, I'm wondering: if several scan commands are
> ...

Ah, the analysis was correct, but not the conclusion. The -EBUSY
wasn't in cfg80211_wext_giwscan(), but in
cfg80211_wext_siwscan().


Hey, I'm talking too much to myself.

/me wishes, the people are back from PDX to normal work :-)

-- 
http://www.holgerschurig.de
