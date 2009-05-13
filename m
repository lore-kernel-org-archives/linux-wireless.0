Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46627 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZEMXPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:15:51 -0400
Received: by fxm2 with SMTP id 2so972542fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 16:15:51 -0700 (PDT)
Subject: Re: [BUG] Connection to an access point is dropped shortly after a
 association
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241606898.18657.2.camel@maxim-laptop>
References: <1241499464.4816.13.camel@maxim-laptop>
	 <1241606898.18657.2.camel@maxim-laptop>
Content-Type: text/plain
Date: Thu, 14 May 2009 02:15:46 +0300
Message-Id: <1242256546.3241.9.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-06 at 13:48 +0300, Maxim Levitsky wrote:
> On Tue, 2009-05-05 at 07:57 +0300, Maxim Levitsky wrote:
> > This is a recent regression.
> > For some access points, eg @ my home, everything is fine as before.
> > But here @ university (open access points) this happens.
> > 
> > Looking at output of 'iw dev wlan 0 station dump' reveals very large
> > 'inactive time'.
> > 
> > Reconnecting restores the connection briefly for yet another 30 seconds
> > or so.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > PS: this is iwlwifi.git commit:
> > 5a94b6d38100b7056a5a347e5c51359d924d305d
> > 
> > 
> > 
> can't seem to reproduce it with wireless-testing of yestarday.
> But I bet that this bug continues to exist.
Yep, this still happens.

I can easily reproduce that, but only at a specific spot, in my
University.

Happens with both old and new firmware.

I continue to investigate, maybe bisect.
Works fine with ubuntu kernel from 9.04.

It can be related to roaming.

Best regards,
	Maxim Levitsky


