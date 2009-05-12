Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48044 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZELUpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 16:45:05 -0400
Received: by gxk10 with SMTP id 10so416388gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 13:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242160485-7395-1-git-send-email-hauke@hauke-m.de>
References: <1241727955-2228-1-git-send-email-hauke@hauke-m.de>
	 <1242160485-7395-1-git-send-email-hauke@hauke-m.de>
Date: Tue, 12 May 2009 16:45:04 -0400
Message-ID: <b6c5339f0905121345u2797d2e9la616294b7a9c8082@mail.gmail.com>
Subject: Re: [PATCH v2] compat-2.6: update compat.diff
From: Bob Copeland <me@bobcopeland.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 4:34 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This will fix the make clean problem reported by Brett D. Ussher.
>
> wl12xx will be removed from Makefile. I do not think wl12xx needs to be integrated,
> because it is not rely widely used.
> If needed it will not be very hard to integrate it.

FWIW, I would like to have wl12xx in compat-wireless.  However, that
is a personal itch to scratch, and I have it sort of working on my own
machine, so you can take this patch now and I can submit a patch later
to properly integrate it with compat-wireless.

-- 
Bob Copeland %% www.bobcopeland.com
