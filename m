Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59199 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0IVNlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:41:49 -0400
Received: by iwn5 with SMTP id 5so575463iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 06:41:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009221458.43434.chunkeey@googlemail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
	<201009221424.39949.chunkeey@googlemail.com>
	<AANLkTikbyQi7dJFrqJrVmr7kV==tZoLRPaufC6tJv743@mail.gmail.com>
	<201009221458.43434.chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 17:41:49 +0400
Message-ID: <AANLkTimm_+4xXf-C2xVW0Q6Dex89Nt9UGKU60j0EAr2T@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alex Mihaylov <minimumlaw@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have Toradex Colibri module ( PXA270 and PXA320 based -
> http://www.toradex.com/Products/Colibri_Modules ) and want connect
> them to Sagrad SG901-1028 module (
> http://www.sagrad.com/index.php?option=com_content&view=article&id=55&Itemid=66
> ) based on STLC450 chip.
>
> Now I add next code to plaform file (kernel 2.6.35.4):
...
> their GPL driver looks funny. (Max, it's really worth a look)
...
> note:
> 2.6.25.4 is very old and the spi subsystem (which isn't backported in cw)
> has changed quite a bit since then.

Alex, what driver is discussed? Christian, what GPL driver?

-- 
Max
