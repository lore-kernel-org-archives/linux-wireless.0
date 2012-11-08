Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65330 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2KHRxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 12:53:18 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so1989486wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 09:53:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352364447-25226-1-git-send-email-phaber@broadcom.com>
References: <1352364447-25226-1-git-send-email-phaber@broadcom.com>
Date: Thu, 8 Nov 2012 18:53:17 +0100
Message-ID: <CACna6ry+nfmmBdk2EMiieGTvrn3U4kpkkDL3yMiZ7MYvpd6nCg@mail.gmail.com> (sfid-20121108_185330_142731_106924A5)
Subject: Re: [PATCH] ssb: fix SPROM offset
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Piotr Haber <phaber@broadcom.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/8 Piotr Haber <phaber@broadcom.com>:
> Offset for temperature compensation
> values is wrong in ssb SPROMv8 map.

Thanks, you can also take a look at "Wrong offset for
SSB_SPROM4_ANTAVAIL?" thread:
http://lists.infradead.org/pipermail/b43-dev/2011-April/001041.html
Not sure if that mistakes were fixed.

-- 
Rafał
