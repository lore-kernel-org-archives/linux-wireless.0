Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:32992 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbZDANMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 09:12:07 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: bitbucket <bitbucket@yandex.ru>
Subject: Re: [ath5k-devel] ath5k I/Q calibration bug
Date: Wed, 1 Apr 2009 15:11:03 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <225921238580960@webmail51.yandex.ru> <200904011242.30747.hs4233@mail.mn-solutions.de> <562851238590311@webmail33.yandex.ru>
In-Reply-To: <562851238590311@webmail33.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200904011511.03588.hs4233@mail.mn-solutions.de> (sfid-20090401_151211_856264_CDA30C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> first of all this patch must be tested by other people, 

Agreed.


> and, if it is good and works right driver maintainers will add
> it to ath5k source by themselves.

Please read Documentation/SubmittingPatches in any recent linux
kernel source, section "12) Signing your work". This 
signed-off-by implies a "Developer's Certificate of Origin".

If you don't do that, than maintainers *CANT* apply your patch, 
even if it is correct. They however could take your idea, and 
write something by themselves. And if the problem is simple 
enought, the actual code might be very similar to yours.

But maybe you want to make life of maintainers easier, not 
harder :-)
