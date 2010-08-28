Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eastrmmtao105.cox.net ([68.230.240.47]:61693 "EHLO
	eastrmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0H1ADY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 20:03:24 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: lance lassetter <lance@lass205.info>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1282721724.3685.0.camel@jlt3.sipsolutions.net>
References: <1282690035.5180.16.camel@lass205.info>
	 <1282721724.3685.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 19:03:23 -0500
Message-ID: <1282953803.4349.2.camel@lass205.info>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-25 at 09:35 +0200, Johannes Berg wrote:
> On Tue, 2010-08-24 at 17:47 -0500, lance lassetter wrote:
> 
> > First is why this didn't happen with kernel 2.6.30?  Connection was
> > automatically up upon thaw being complete.
> 
> I have no idea. 2.6.30 is very long ago.
> 
> > Second is how to restore wireless connectivity upon resume from
> > hibernation without having to manually restart the network?
> 
> Run wpa_supplicant.

works like a charm, thanks Johannes.  If you need anything tested,
please let me know.
