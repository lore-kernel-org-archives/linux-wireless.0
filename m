Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:34533 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2HZNxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 09:53:33 -0400
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx
 packet length validity check
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 26 Aug 2012 17:53:25 +0400
In-Reply-To: <20120821114343.GB2380@redhat.com>
References: <20120820205355.7ccc0450@emcraft.com>
	 <20120821114343.GB2380@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Message-ID: <1345989206.8762.3.camel@mehome> (sfid-20120826_155412_998592_2944F38A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Tue, 2012-08-21 at 13:43 +0200, Stanislaw Gruszka wrote:
> >       /*
> > -      * Remove the RXINFO structure from the sbk.
> > +      * Remove the RXINFO structure from the skb.
> >        */
> >       skb_pull(entry->skb, RXINFO_DESC_SIZE);
> Would be great if you could post this as separate patch.

I'm sending the patch for this typo in the follow-up email.

Regards,
Sergei

