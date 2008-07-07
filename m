Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:51826 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbYGGVKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:10:10 -0400
Received: by yx-out-2324.google.com with SMTP id 8so517214yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:10:09 -0700 (PDT)
Message-ID: <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com> (sfid-20080707_231014_750400_F0F78358)
Date: Mon, 7 Jul 2008 23:10:08 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Cc: rt2400-devel@lists.sourceforge.net,
	"Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807072308.57529.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
	 <200807072308.57529.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Check if the arc4 and ecb modules are loaded before loading mac80211 & rt2500pci.
>
> Ivo

Shouldn't we make mac80211 depend on arc4 and ecb?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
