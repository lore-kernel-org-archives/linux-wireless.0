Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:56857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab0E1RJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 13:09:57 -0400
Subject: Re: MDNS is broken in latest -git
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1275058948.2754.7.camel@maxim-laptop>
References: <1275058948.2754.7.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 20:09:51 +0300
Message-ID: <1275066591.3390.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 18:02 +0300, Maxim Levitsky wrote: 
> On latest git, it became impossible to use hostname.local alias to
> access my network hosts.
> 
> In fact when I look at 'avahi-discover' I see nothing but local
> services.
> 
> I did a bisect, but unfortunely ended with merge commit, although
> bisection seem to be normal (and I didn't do any shortcuts).

Since starting 'wireshark' magicly temporarly fixes this, I suspect that
mulicast packets don't get through.

This smells like iwl3945 bug.

I use linus' master tree now.

Best regards,
Maxim Levitsky

