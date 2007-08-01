Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:32615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbXHAQqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 12:46:02 -0400
Received: by ug-out-1314.google.com with SMTP id j3so234959ugf
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2007 09:46:01 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Wed, 1 Aug 2007 18:50:08 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20070731115446.5717.37617.stgit@localhost> <46AF51C5.6070507@warmcat.com> <46AFB98C.5020203@warmcat.com>
In-Reply-To: <46AFB98C.5020203@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708011850.08406.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 August 2007, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> >> Ok, that was easier then I thought, rt2x00 2.0.5 _will_ contain the fix for this.
> >> I just noticed that when the first and only interface is a monitor interface
> >> the device was not being configured at all. This has now been fixed in rt2x00.git,
> >> so it will be part of the 2.0.5 release later today. :)
> > 
> > Great, I will check for it on the serialmonkey site later and give it a go.
> 
> Ah I saw it went to git.kernel.org
> 
> Yes current rt2x00 git in there works fine for simple monitor mode
> now... thanks a lot for your hard work!

Excellent! Good to hear that is working completely now. :)

Ivo
