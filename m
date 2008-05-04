Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:27721 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYEDJlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 05:41:32 -0400
Received: by ug-out-1314.google.com with SMTP id h3so489768ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2008 02:41:30 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: multiqueue
Date: Sun, 4 May 2008 11:47:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805040035.05512.IvDoorn@gmail.com> <200805040115.24553.IvDoorn@gmail.com> <1209856663.3920.2.camel@johannes.berg>
In-Reply-To: <1209856663.3920.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805041147.37334.IvDoorn@gmail.com> (sfid-20080504_114106_057803_D3FD19AF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 May 2008, Johannes Berg wrote:
> 
> > 	if (!mdev)
> > 		goto fail_mdev_alloc;
> > 	if (hw->queues > 1)
> > 		mdev->flags |= NETIF_F_MULTI_QUEUE;
> > 
> > So theoretically this flag should be set.
> > However /sys/class/net/wmaster1/features contains the value 0x0
> 
> Yes, umm, guess why. That line should be mdev->features |= ...

That did the trick. :)

Thanks,

Ivo
