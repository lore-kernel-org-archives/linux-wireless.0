Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:34521 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab0CYVDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 17:03:00 -0400
Received: by pzk32 with SMTP id 32so2119188pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100321T212710-762@post.gmane.org>
References: <4B5CD1FF.4090209@twilightblue.net>
	 <loom.20100321T212710-762@post.gmane.org>
Date: Thu, 25 Mar 2010 17:02:47 -0400
Message-ID: <b6c5339f1003251402sa2faff0m42e1a7fef7356e13@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
From: Bob Copeland <me@bobcopeland.com>
To: nanok <nanokk@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 21, 2010 at 4:49 PM, nanok <nanokk@gmx.net> wrote:
>
> i can confirm don's issue. i have been using several revisions of 2.6.32
> (debian, not vanilla, it's true), i have resorted (back) to using
> ath-pci
> instead (i had been using it before because of the nifty functionality,
> but i
> switched to ath5k lately because of it being included in the kernel).
>
> reading don's report here, i tried using the 2.6.30 i already have, it
> seems
> to work fine

As you are using debian I have to ask: have you installed
crda?  Since 2.6.30 ath5k gained regulatory support which
may cause certain channels to be disabled.

-- 
Bob Copeland %% www.bobcopeland.com
