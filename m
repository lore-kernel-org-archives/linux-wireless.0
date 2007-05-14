Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:42475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbXENU73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 16:59:29 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1433645uga
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2007 13:59:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3 1/2] Add 93cx6 eeprom library
Date: Mon, 14 May 2007 22:57:50 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <200705140138.52596.flamingice@sourmilk.net> <200705141700.21900.IvDoorn@gmail.com> <20070514181323.GB6999@tuxdriver.com>
In-Reply-To: <20070514181323.GB6999@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705142257.50726.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > The udelay is necessary to set a limit on how fast the eeprom is operated.. 
> > > but not on all hardware, apparently. adm8211 just uses a read from the eeprom 
> > > register to perform the delay.
> > 
> > Ok, then I'll update rt2x00 to perform the delay during register_write as well. :)
> 
> Actually, see the end of the thread from the previous 93cx6 patch
> Michael posted on Friday.  I think these delays are actually alright,
> but they could use a comment.  How about the patch below (applied on
> top of the previous version)?

Not a problem, I'll create one for wireless-dev but it should be applicable
for wireless with Michael's patch as well. :)

Ivo
