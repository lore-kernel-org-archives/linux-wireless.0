Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:38584 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZG0PJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:09:11 -0400
Received: by qyk11 with SMTP id 11so703185qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 08:09:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090727092714.218550@gmx.net>
References: <20090727092714.218550@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Mon, 27 Jul 2009 08:08:51 -0700
Message-ID: <43e72e890907270808k5c1668f4odc7f14785615635f@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: update for master-2009-07-24 wireless-testing
To: Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 2:27 AM, Joerg Albert<jal2@gmx.de> wrote:
> drivers/net/usb/Makefile: remove cdc-phonet
>
> Signed-off-by: Joerg Albert <jal2@gmx.de>

Didn't apply but applied something similar. Pushed out a new tarball.

git-describe for wireless-testing.git says: v2.6.31-rc4-29150-g77206c0
This is a bleeding edge compat-wireless release based on: master-2009-07-26
This is compat-release: master-2009-07-26-2-g6295a8a

  Luis
