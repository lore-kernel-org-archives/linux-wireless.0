Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37524 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0CZDwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 23:52:39 -0400
Received: by vws8 with SMTP id 8so1255430vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 20:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100325230445.GB7547@spartakus>
References: <4B5CD1FF.4090209@twilightblue.net>
	 <loom.20100321T212710-762@post.gmane.org>
	 <b6c5339f1003251402sa2faff0m42e1a7fef7356e13@mail.gmail.com>
	 <b6c5339f1003251404p624d7f15mae54813453821b33@mail.gmail.com>
	 <20100325222400.GA7547@spartakus>
	 <b6c5339f1003251544r35b59c8fqf6a9beeaa3264b82@mail.gmail.com>
	 <20100325230445.GB7547@spartakus>
Date: Thu, 25 Mar 2010 23:52:37 -0400
Message-ID: <b6c5339f1003252052u12de166bjda656ce6db75f254@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
From: Bob Copeland <me@bobcopeland.com>
To: nanokk@gmx.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 7:04 PM, nanok <rnanok@gmail.com> wrote:
> wpa works with wpa_supplicant, i haven't tested in a while, but i can as
> soon as i get home. plain also works (no encryption). iirc, the original
> "plaintif" experienced the same.
>
> to keep things accurate, i have experienced again a lock up (kernel
> panick) while i was trying to get the wlan0 up (ath5k), and getting
> errors, so now i have switched back to ath-pci

If you can manage to capture the panic, that would
be helpful, for example by switching to a console
beforehand and taking a picture with a digital camera.

(Still wishing for KMS to solve this problem...)

-- 
Bob Copeland %% www.bobcopeland.com
