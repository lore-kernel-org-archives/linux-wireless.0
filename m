Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:40552 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab1AaKop (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 05:44:45 -0500
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [BUG] iwlwifi need to correct channels info
Date: Mon, 31 Jan 2011 19:44:42 +0900
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
References: <20110128154100.GB2452@redhat.com> <1296237969.5118.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296237969.5118.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101311944.42513.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 January 2011 03:06:09 Johannes Berg wrote:
> On Fri, 2011-01-28 at 16:41 +0100, Stanislaw Gruszka wrote:
> > After commit 59eb21a6504731fc16db4cf9463065dd61093e08
> > "cfg80211: Extend channel to frequency mapping for 802.11j"
> > 5GHz networks are not seen on scan results.
> > 
> > I think above commit is correct, but we have broken channel
> 
> > information on iwlwifi (freq is 0 on 5GHz channels):
> No, the above commit is buggy -- it assumes sband->band is set when it
> isn't. Does this fix it?
> 
> Bruno can you please verify you haven't made that mistake elsewhere?

Honestly, I can't. Really sorry.

bruno
