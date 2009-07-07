Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZGGPU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 11:20:56 -0400
Subject: Re: 4965AGN loses connection on Custom wireless event
From: Dan Williams <dcbw@redhat.com>
To: Jan Willies <jan@willies.info>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A535168.4050800@willies.info>
References: <4A4B5EC8.8060804@willies.info>
	 <1246458585.12198.114.camel@localhost.localdomain>
	 <4A535168.4050800@willies.info>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:21:03 -0400
Message-Id: <1246980063.28570.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-07 at 15:45 +0200, Jan Willies wrote:
> Hi,
> 
> On 01.07.2009 16:29, Dan Williams wrote:
> > Jouni, how should the supplicant handle a WEXT assoc event for the AP
> > that's already associated with?  That seems to be what's going on here;
> > the card is coming back from a scan and emitting an assoc event (not
> > sure why) and that's making the supplicant (wrongly IMHO) try to reauth
> > at the EAP level for some reason.
> 
> Did I miss the answer here? Is there any more information I can provide?

Nope, not yet.  Jouni's traveling at the moment though so he might reply
when he gets back.

Dan


