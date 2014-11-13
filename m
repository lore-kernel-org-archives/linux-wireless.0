Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbaKMXNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 18:13:24 -0500
Date: Fri, 14 Nov 2014 00:13:23 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Jonathan Doron <jond@wizery.com>
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy
	specific regd info
Message-ID: <20141113231323.GG24486@wotan.suse.de> (sfid-20141114_001327_310466_A9EA653D)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <1415895219-19848-4-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415895219-19848-4-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2014 at 06:13:39PM +0200, Arik Nemtsov wrote:
> From: Jonathan Doron <jond@wizery.com>
> 
> Allow usermode to query wiphy-specific regd info, for drivers that use
> wiphy-specific regulatory management.
> 
> Use the existing API for sending regdomain info to usermode, but return
> the wiphy-specific regd in case wiphy index is provided and the driver
> employs wiphy-specific management. This implies user and kernel-mode
> support for the feature and is backward compatible.

This patch does not address my feedback about making this generic
to any wiphy->regd.

  Luis
