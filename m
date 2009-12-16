Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:52813 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428AbZLPIFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 03:05:34 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Wed, 16 Dec 2009 09:03:52 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <20091215190051.GC2123@tux> <20091215190248.GE2123@tux>
In-Reply-To: <20091215190248.GE2123@tux>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912160903.53141.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> And if your IBSS and the AP already sent the coverage class
> through the country IE I am not sure if we should allow
> overriding it. 

Hmm, I think a local setting should override some broadcasted 
setting *IF* this cannot be used for some kind of 
denial-of-service-attack on links farther away.

But if the AP says "I'm 20 km away from you", but you *KNOW* that 
you're only 100 m fromt he AP, you should be able to override 
this --- again, if this wouldn't harm the operation of another 
device which is really 20 km away.

-- 
http://www.holgerschurig.de
