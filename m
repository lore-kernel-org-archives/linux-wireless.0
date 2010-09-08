Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0IHLel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 07:34:41 -0400
Received: by fxm16 with SMTP id 16so622971fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 04:34:39 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt61pci: oops in rt2x00lib_txdone(), entry->skb is NULL
Date: Wed, 8 Sep 2010 13:33:56 +0200
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
References: <1283902212.5071.11.camel@mj> <AANLkTimFYCKGe2v9JF-aBozoKvHnUDw6B6Uj2K6rAwKk@mail.gmail.com> <20100908065926.6wrt16onsckcocsk-cebfxv@webmail.spamcop.net>
In-Reply-To: <20100908065926.6wrt16onsckcocsk-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009081333.56721.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 08 September 2010 schrieb Pavel Roskin:
> Quoting Ivo Van Doorn <ivdoorn@gmail.com>:
> 
> > Nice catch, this is indeed an obvious bug :S
> 
> The patch is working for me.  Thanks!

Great, thanks for testing ...
