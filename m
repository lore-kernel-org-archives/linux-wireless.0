Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61519 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZHCU3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:29:46 -0400
Received: by gxk9 with SMTP id 9so6148999gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 13:29:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090803195816.GG18639@mail.wantstofly.org>
References: <20090803195816.GG18639@mail.wantstofly.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 13:29:26 -0700
Message-ID: <43e72e890908031329p7afcc94bg7d101a41041b46b2@mail.gmail.com>
Subject: Re: [PATCH 0/5] various mwl8k bugfixes
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nico@cam.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 12:58 PM, Lennert
Buytenhek<buytenh@wantstofly.org> wrote:
> This patch series fixes a couple of potential crashes and hangs in
> mwl8k, and some other misbehaviour.  They are against current linus
> tree, which is 2.6.31-rc5 plus some.  Please consider applying.

BTW mind adding a MAINTAINERS entry for this driver?

  Luis
