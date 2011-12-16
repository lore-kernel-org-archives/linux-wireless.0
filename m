Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab1LPI1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 03:27:51 -0500
Subject: Re: QoS frames in AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAGXE3d8iseEhF2+w2riO=w_aMDdi8Uv4+w7URCM+PxYG19eYww@mail.gmail.com> (sfid-20111216_091455_019524_E5D93AF3)
References: <CAGXE3d9dCL+tnXg5ero51cxf3T9VPVgv8oKo51Vi_gWd8as9Xw@mail.gmail.com>
	 <1323968408.31153.1.camel@jlt3.sipsolutions.net>
	 <CAGXE3d8iseEhF2+w2riO=w_aMDdi8Uv4+w7URCM+PxYG19eYww@mail.gmail.com>
	 (sfid-20111216_091455_019524_E5D93AF3)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 09:27:48 +0100
Message-ID: <1324024068.3429.0.camel@jlt3.sipsolutions.net> (sfid-20111216_092754_995498_F025152C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-16 at 09:14 +0100, Helmut Schaa wrote:
> On Thu, Dec 15, 2011 at 6:00 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> 
> >>         /* skb->priority values from 256->263 are magic values to
> >>          * directly indicate a specific 802.1d priority.  This is used
> >>          * to allow 802.1d priority to be passed directly in from VLAN
> >>          * tags, etc.
> >>          */
> >>         if (skb->priority >= 256 && skb->priority <= 263)
> >>                 return skb->priority - 256;
> 
> Is this code still valid? I haven't found a reference in the 802.1q code :(

I always thought you'd use like iptables to set it to the right value,
but I have no idea.

johannes

