Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaEONLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 09:11:15 -0400
Message-ID: <1400159466.4146.4.camel@jlt4.sipsolutions.net> (sfid-20140515_151118_823144_A47EC7E3)
Subject: Re: [PATCH 0/8] mac80211/cfg80211/iwlwifi: a few channel-switch
 patches
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Thu, 15 May 2014 15:11:06 +0200
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-09 at 14:11 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Hi,
> 
> These are a few channel-switch patches by Andrei that we have in our
> internal tree.  I have rebased them for upstream.

Applied the cfg80211/mac80211 changes, but please ... that cover letter
was useless, and your patch set had build breakage in the middle. :)

I fixed that with along with some minor editing changes and a change to
the netlink dump as well.

johannes

