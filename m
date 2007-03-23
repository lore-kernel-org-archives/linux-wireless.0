Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33448 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992478AbXCWPyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 11:54:05 -0400
Date: Fri, 23 Mar 2007 16:54:00 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] d80211: Stop virtual interfaces during scan
Message-ID: <20070323165400.353e713f@griffin.suse.cz>
In-Reply-To: <200703010040.14598.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<20070228203943.11473.81749.stgit@magic.sourmilk.net>
	<200703010040.14598.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 Mar 2007 00:40:09 -0500, Michael Wu wrote:
> On Wednesday 28 February 2007 15:39, Michael Wu wrote:
> > From: Michael Wu <flamingice@sourmilk.net>
> >
> > This prevents data frames from being queued on the master device if it is
> > in the midst of a scan. It also makes both master and virtual interfaces
> > properly set trans_start when frames are sent so the network watchdog does
> > not try to reset the interfaces. tx_queue_len is left as the default on
> > virtual interfaces to allow frames to be queued while the device is
> > scanning.
> >
> And now that all STA interfaces are woken up after a scan, we also can remove 
> the scan_dev check.

Looks good, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
