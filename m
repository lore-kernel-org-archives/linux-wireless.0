Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36984 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161339AbXBOV2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 16:28:32 -0500
Date: Thu, 15 Feb 2007 22:28:30 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Fix concurrency issues in ieee80211_sta.c
Message-ID: <20070215222830.5f439a4a@griffin.suse.cz>
In-Reply-To: <200702090237.51978.flamingice@sourmilk.net>
References: <200702090002.29841.flamingice@sourmilk.net>
	<200702090028.56793.flamingice@sourmilk.net>
	<200702090237.51978.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 02:37:43 -0500, Michael Wu wrote:
> This fixes most concurrency issues in ieee80211_sta.c and partially
> prevents scans from running over an association in progress and vice versa.
> This is achieved by forcing all potentially racy code to run from a
> workqueue.

Applied to my tree, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
