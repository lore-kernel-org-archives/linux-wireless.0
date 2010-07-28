Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0G1GxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 02:53:23 -0400
Date: Wed, 28 Jul 2010 08:53:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [stable] [PATCH 2/2 2.6.32.y] mac80211: fix supported rates IE
 if AP doesn't give us it's rates
Message-ID: <20100728085305.5a51279b@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100727223932.GL14257@kroah.com>
References: <1275904783-6563-1-git-send-email-sgruszka@redhat.com>
	<1275904783-6563-2-git-send-email-sgruszka@redhat.com>
	<20100727223932.GL14257@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Jul 2010 15:39:32 -0700
Greg KH <greg@kroah.com> wrote:

> On Mon, Jun 07, 2010 at 11:59:43AM +0200, Stanislaw Gruszka wrote:
> > If AP do not provide us supported rates before assiociation, send
> > all rates we are supporting instead of empty information element.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  net/mac80211/mlme.c |   17 +++++++++++------
> 
> What is the commit id of this patch upstream?

76f273640134f3eb8257179cd5b3bc6ba5fe4a96


Cheers
Stanislaw
