Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1BSJEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:04:44 -0500
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110215130428.GA2515@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
	 <1297698696.4723.16.camel@wwguy-ubuntu> <20110215113444.GC2162@redhat.com>
	 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
	 <20110215130428.GA2515@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 10:04:40 +0100
Message-ID: <1298106280.3725.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 14:04 +0100, Stanislaw Gruszka wrote:

> > Agree, but I wish the timer objects had a name so we'd know what it
> > was ... hmm, how can we figure out which timer this is?
> 
> By patching kernel :-)
> http://people.redhat.com/sgruszka/debugobj-add-timer-name.patch

Btw, I think you should consider submitting that or a similar patch into
the kernel proper. I'm sure other subsystems could also benefit from
having this information.

Should be "const char *name" though throughout :-)

johannes

