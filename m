Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37098 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753386AbXCWTBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:32 -0400
Date: Fri, 23 Mar 2007 20:01:30 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during  scan
Message-ID: <20070323200130.3f8d36ac@griffin.suse.cz>
In-Reply-To: <200703231405.20085.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<200703010043.10565.flamingice@sourmilk.net>
	<20070323170136.5f6205db@griffin.suse.cz>
	<200703231405.20085.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 14:05:15 -0400, Michael Wu wrote:
> ieee80211_sta_timer just schedules the workqueue to run. I'm not sure if the 
> workqueue can run immediately after that, but even if it did, the sta code 
> doesn't depend on the queue of a virtual interface so these lines don't need 
> to run in any particular order.

Okay, you're right. Applied, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
