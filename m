Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3594 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031109AbXDYSwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 14:52:10 -0400
Date: Wed, 25 Apr 2007 14:16:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070425181656.GD5875@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184814.7029.8413.stgit@magic.sourmilk.net> <462EE107.8040005@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <462EE107.8040005@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2007 at 10:03:03PM -0700, James Ketrenos wrote:

> (I would like to see hw_scan remain since iwlwifi uses it -- which we hope 
> to submit as soon as the code restructuring is complete)

I was going to mention this in response to Michael's patch, but then
I checked your current iwlwifi git tree.  There your hw_scan routine
is commented-out, so I figured you didn't want/need it anymore...?

John
-- 
John W. Linville
linville@tuxdriver.com
