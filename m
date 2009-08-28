Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:36838 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZH1Hfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 03:35:33 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ar9271 mailing list and driver project page
Date: Fri, 28 Aug 2009 09:34:53 +0200
Cc: devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <43e72e890908271943s6dca1257g1f1e56d0347cc21d@mail.gmail.com>
In-Reply-To: <43e72e890908271943s6dca1257g1f1e56d0347cc21d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908280934.53681.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> ar9271 and ar9170 seem to share a few things, one of which is
> firmware upload. ar9271's firmware upload routine was modified
> to make it match ar9170's as much as possible to share it on
> ath.ko

Is it true that most devices which will use ath.ko won't ever use 
firmware uploading?  It's only a few Ath-USB devices, so maybe 
you could do an ath_fw.ko for this.

(Somebody who's always working with embedded devices and likes to 
keeps small :-)

-- 
http://www.holgerschurig.de
