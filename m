Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41132 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755938AbXD0PXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:23:11 -0400
Date: Fri, 27 Apr 2007 17:23:32 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add sta item when changing WDS address
Message-ID: <20070427172332.0d69f013@griffin.suse.cz>
In-Reply-To: <1177686772.3565.32.camel@johannes.berg>
References: <1175011277.9282.8.camel@johannes.berg>
	<1177686772.3565.32.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 17:12:52 +0200, Johannes Berg wrote:
> On Tue, 2007-03-27 at 18:01 +0200, Johannes Berg wrote:
> > This patch adds a sta item for the new address when you change a WDS
> > link's address. If the sta item cannot be created return an error.
> 
> Anything wrong with this patch? :)

It's in wireless-dev for quite some time (commit
d80bb18ca3444520b465f3006bbb78837a5e28d9). Did I miss some problem when
I was looking at the patch?

 Jiri

-- 
Jiri Benc
SUSE Labs
