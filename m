Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59701 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933193AbXCURZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 13:25:07 -0400
Date: Wed, 21 Mar 2007 18:25:05 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] d80211: Set carrier status for STA interfaces
Message-ID: <20070321182505.2260a9a8@griffin.suse.cz>
In-Reply-To: <20070228203943.11473.36193.stgit@magic.sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<20070228203943.11473.36193.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Feb 2007 15:39:43 -0500, Michael Wu wrote:
> This makes STA interfaces set the carrier status based on the current
> association status.

Does this really work? Last time I checked, when the carrier is off, no
frames are sent to hard_start_xmit.

 Jiri

-- 
Jiri Benc
SUSE Labs
