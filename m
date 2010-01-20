Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:37948 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab0ATQ5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 11:57:25 -0500
From: "Frank W. Miller" <frankwmiller@frankwmiller.net>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC> <1263982605.14538.4.camel@johannes.local>
In-Reply-To: <1263982605.14538.4.camel@johannes.local>
Subject: RE: wireless for manet experiments
Date: Wed, 20 Jan 2010 09:57:23 -0700
Message-ID: <08DFA78E8F5440BAABB710E4D662EC2E@FrankWMillerPC>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Thanks for the reply.  Is there documentation on the injection and monitor
interfaces you mention?  Where would I learn about how to paste in a tun
interface later on?

Thanks,
FM


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Johannes Berg
> Sent: Wednesday, January 20, 2010 3:17 AM
> To: Frank W. Miller
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: wireless for manet experiments
> 
> On Tue, 2010-01-19 at 14:19 -0700, Frank W. Miller wrote:
> 
> > 1) disconnect the wireless interface from the IP stack and access it
> > directly from user space
> >
> > 2) later, I'd like to interpose the Layer 2 protocol between the
> > wireless
> > interface and the IP network stack.
> >
> > What is the best way to go about these things?
> 
> In addition to what Bob said, regardless of what you want to do I would
> probably just do it all in userspace with injection and monitor
> interfaces, and then for IP offer tun interfaces to the kernel again. At
> least for a prototype.
> 
> johannes

