Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:57153 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3KYW7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 17:59:06 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so2214876bkb.26
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 14:59:05 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: p2p@posteo.de, linux-wireless@vger.kernel.org
Subject: Re: RTL8188S
Date: Mon, 25 Nov 2013 23:59:03 +0100
Message-ID: <2275033.1QHi5CsvI8@blech> (sfid-20131125_235911_458165_C7DA3B54)
In-Reply-To: <5293CB3E.6090104@lwfinger.net>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> <2035998.63y5xTAJxx@blech> <5293CB3E.6090104@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 25, 2013 04:12:14 PM Larry Finger wrote:
> On 11/25/2013 03:57 PM, Christian Lamparter wrote:
> >> I thought RTL8192cu will work, but Larry F. told me it doesn't.
> > OK? (care to explain?)
> 
> The driver for an RTL81{88,92}CU device (rtl8192cu) will not work for the 
> RTL81{88,92}SU device. There are substantial differences between the CU and SU 
> chips.

Thanks. I first thought a RTL81xyCU device was involved somehow (for example
as the P2P GO peer on the other end, or as a replacement for rtl8192su device).

But apparently not... well, that's too bad.

Regards

Christian
