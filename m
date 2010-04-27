Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3092 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900Ab0D0Tlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 15:41:52 -0400
Message-ID: <4BD73DFE.3010502@gmail.com>
Date: Tue, 27 Apr 2010 21:41:50 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800lib: Fix rx path on SoC devices
References: <201004261348.45044.helmut.schaa@googlemail.com> <4BD609C9.1080005@gmail.com> <201004270828.17303.helmut.schaa@googlemail.com> <4BD7270B.6050000@gmail.com> <20100427181551.GA32012@tuxdriver.com>
In-Reply-To: <20100427181551.GA32012@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/10 20:15, John W. Linville wrote:
> On Tue, Apr 27, 2010 at 08:03:55PM +0200, Gertjan van Wingerde wrote:
> 
>> P.S. It seems that John already applied this patch without even Ivo or me Acking it, so I guess an
>> incremental patch would be best now.
> 
> Yes, sorry if that offends -- "fix rx path" makes me take things seriously. :-)
> 

Don't worry about it. No offense was taken. It was more a surprise to see it been applied before
I even had to chance to review it, but the patch in itself is correct, it just needs a bit polishing.

---
Gertjan.
