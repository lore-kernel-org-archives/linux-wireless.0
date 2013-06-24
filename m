Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3FXPpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:45:40 -0400
Message-ID: <1372088725.8439.18.camel@jlt4.sipsolutions.net> (sfid-20130624_174543_162498_0E63FFED)
Subject: Re: [PATCH 3.9 4/4] iwlwifi: mvm: reduce the number of supported
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 17:45:25 +0200
In-Reply-To: <20130624152631.GA13886@kroah.com> (sfid-20130624_172553_217110_C6225AB7)
References: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1372079945-7445-4-git-send-email-emmanuel.grumbach@intel.com>
	 <20130624152631.GA13886@kroah.com> (sfid-20130624_172553_217110_C6225AB7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-24 at 08:26 -0700, Greg Kroah-Hartman wrote:
> On Mon, Jun 24, 2013 at 04:19:05PM +0300, Emmanuel Grumbach wrote:
> > The driver in 3.9 can't support more than one interface
> > concurrently. The parameters given to cfg80211 were wrong.
> > Next versions are fixed by allowing concurrent interfaces.
> > This is why you won't see this patch upstream.
> 
> So this isn't an issue in 3.10 at all?

The dangers of stable-only patches ... I think this was actually
introduced into 3.9 only in my commit
2e8a935b639356f8397d39b118ac914d99b55871 ("iwlwifi: mvm: remove
P2P_DEVICE support"). Sorry about that.

johannes

