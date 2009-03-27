Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54768 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785AbZC0CDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 22:03:54 -0400
Received: by fxm2 with SMTP id 2so833914fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 19:03:51 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: p54spi - mesh mode summary
Date: Fri, 27 Mar 2009 04:55:23 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200903261933.53998.chunkeey@web.de>
In-Reply-To: <200903261933.53998.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903270455.24129.jcmvbkbc@gmail.com> (sfid-20090327_030357_930836_EBFF7B96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I see constant beacon resubmission cycle. How does it work on pci/usb
> > p54?
>
> firmware does it... all we need is to submit a beacon template. The
> firmware knows how to extract everything it needs (e.g intervals/dtim etc.)
> out of the frame itself...

> > But if there's real problem in firmware, I'd consider it mere
> > workaround and put it back.
>
> yes please do... And don't worry the frame which we'll pass to mac80211
> will always have the correct length, even when the extra padding wasn't
> used.

Thanks for your explanation, it is very useful and encouraging (:

-- 
Max
