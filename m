Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35544 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0IVNsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:48:36 -0400
Received: by fxm3 with SMTP id 3so279682fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 06:48:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
Date: Wed, 22 Sep 2010 15:48:27 +0200
Cc: Alex Mihaylov <minimumlaw@gmail.com>,
	linux-wireless@vger.kernel.org
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com> <201009221458.43434.chunkeey@googlemail.com> <AANLkTimm_+4xXf-C2xVW0Q6Dex89Nt9UGKU60j0EAr2T@mail.gmail.com>
In-Reply-To: <AANLkTimm_+4xXf-C2xVW0Q6Dex89Nt9UGKU60j0EAr2T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221548.28159.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 15:41:49 Max Filippov wrote:
> > I have Toradex Colibri module ( PXA270 and PXA320 based -
> > http://www.toradex.com/Products/Colibri_Modules ) and want connect
> > them to Sagrad SG901-1028 module (
> > http://www.sagrad.com/index.php?option=com_content&view=article&id=55&Itemid=66
> > ) based on STLC450 chip.
> >
> > Now I add next code to plaform file (kernel 2.6.35.4):
> ...
> > their GPL driver looks funny. (Max, it's really worth a look)
> ...
> > note:
> > 2.6.25.4 is very old and the spi subsystem (which isn't backported in cw)
> > has changed quite a bit since then.
> 
> Alex, what driver is discussed? Christian, what GPL driver?
Oh I'm sorry, I forgot to add the "irony" GPL tags.

Anyway, take a look at the product page, there you can download
the their driver "demo".
