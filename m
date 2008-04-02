Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:7047 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYDBXnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 19:43:00 -0400
Received: by py-out-1112.google.com with SMTP id u52so4120035pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 16:42:59 -0700 (PDT)
Message-ID: <43e72e890804021642u4dd7b329w60344c991e2a7e43@mail.gmail.com> (sfid-20080403_004306_465778_86629D2D)
Date: Wed, 2 Apr 2008 19:42:59 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Chr <chunkeey@web.de>
Subject: Re: [RFC][PATCH 0/4] p54: various updates
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <200804012339.37204.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200804012339.37204.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 1, 2008 at 5:39 PM, Chr <chunkeey@web.de> wrote:
> Hi,
>
>  this is the next RFC round...
>
>  1) rename all prism54* to p54* (to match the filenames)
>  2) rx_tasklet for p54pci
>  3) link statistics
>  4) AP-Patch
>
>  Signed-off-by: Christian Lamparter <chunkeey@web.de>

Thanks, can you resend as inline patches so it can help get better
review. Also while you're at it can you stuff all p54 files into its
own folder?

  Luis
