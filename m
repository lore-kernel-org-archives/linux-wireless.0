Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2545 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYFYRgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 13:36:53 -0400
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with product
	id0x8197/0x8189
From: Pavel Roskin <proski@gnu.org>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
In-Reply-To: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 13:36:51 -0400
Message-Id: <1214415411.7901.25.camel@dv> (sfid-20080625_193657_434840_FE82DC2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 11:59 -0500, Larry.Finger@lwfinger.net wrote:

> I have a few questions during the porting:
> 
> - control->queue, which the herton's change used, for switching between 4
> tramission queue at end point 6,7,5,4, has disappeared. I hard-coded 6 in
> this version, (see commemt #37 for background), but what's the correct
> way to do this in current wireless-2.6 code?

Where did you do it?  The patch you posted uses skb_get_queue_mapping.

> The original message from Herton follows:
> 
> I'm posting this patch mostly to share my results so far and take that
> burden from me.  I have no desire to take over maintenance of that
> driver or to answer any support requests.

I wrote that.

-- 
Regards,
Pavel Roskin
