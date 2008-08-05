Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760385AbYHEUZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:25:35 -0400
Subject: Re: hostap: handling device renames better
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217967824.3603.62.camel@johannes.berg>
References: <1217967821.29886.4.camel@localhost.localdomain>
	 (sfid-20080805_222207_764541_7BCED377)  <1217967824.3603.62.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 16:27:19 -0400
Message-Id: <1217968039.29886.6.camel@localhost.localdomain> (sfid-20080805_222538_169631_8C17D175)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 22:23 +0200, Johannes Berg wrote:
> On Tue, 2008-08-05 at 16:23 -0400, Dan Williams wrote:
> 
> > How are drivers made aware that their device's name has changed so they
> > could potentially update things they stick in /proc or wherever?  hostap
> > and airo come to mind as current users of /proc.
> 
> You can register a netdevice notifier and follow the renames. mac80211
> does this for the debugfs dir.

Ok, will look into this.  Thanks!

Dan

