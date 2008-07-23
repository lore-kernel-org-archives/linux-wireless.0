Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:56108 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYGWROL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:14:11 -0400
Received: by an-out-0708.google.com with SMTP id d40so534714and.103
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 10:14:10 -0700 (PDT)
Message-ID: <43e72e890807231014rbbe57adgfdefd062f64de718@mail.gmail.com> (sfid-20080723_191415_558383_F755586F)
Date: Wed, 23 Jul 2008 10:14:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] ath9k: use correct type for test_bit/set_bit
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <20080723165314.GA30144@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080723165314.GA30144@lst.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 9:53 AM, Christoph Hellwig <hch@lst.de> wrote:
> The test_bit/set_bit/etc family of routines operates on arrays of
> unsigned long, so declare sc_keymap as such using the DECLARE_BITMAP
> helper.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
