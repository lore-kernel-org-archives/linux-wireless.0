Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:33956 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0BWT20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 14:28:26 -0500
Received: by pxi29 with SMTP id 29so2225845pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 11:28:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100223095113.25360.75291.stgit@void>
References: <20100223095113.25360.75291.stgit@void>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Feb 2010 11:28:06 -0800
Message-ID: <43e72e891002231128w45c357a6v157dc4f7ddf3bbae@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix rates setup on IBSS merge
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 1:51 AM, Bruno Randolf <br1@einfach.org> wrote:
> when an IBSS merge happened, the supported rates for the newly added station
> were left empty, causing the rate control module to be initialized with only
> the basic rates.
>
> also the section of the ibss code which deals with updating supported rates for
> an already existing station fails to inform the rate control module about the
> new rates. as i don't know how to fix this (minstrel does not have an update
> function), i have just added a comment for now.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

This seems like a stable fix, if it applies can you please resend with a

Cc: stable@kernel.org

on the commit log entry right below your own SOB.

  Luis
