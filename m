Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58648 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933318AbXD2P6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 11:58:42 -0400
Date: Sun, 29 Apr 2007 17:58:39 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: remove hostapd scanning
Message-ID: <20070429175839.46b61840@logostar.upir.cz>
In-Reply-To: <200704291127.00777.flamingice@sourmilk.net>
References: <20070429155623.3a7f1a67@logostar.upir.cz>
	<200704291127.00777.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Apr 2007 11:27:00 -0400, Michael Wu wrote:
> On Sunday 29 April 2007 09:56, Jiri Benc wrote:
> > This removes passive_scan callback with associated code. The whole thing is
> > not a job for a driver and can be done in a much cleaner way using user
> > space MLME. Besides, nobody (not even hostapd) uses that call.
> >
> Well, if we're gonna get rid of this, we can kill ieee80211_netif_oper for 
> good since ieee80211_scan.c was the last user.

Good catch. Thanks.

 Jiri

-- 
Jiri Benc
SUSE Labs
