Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4634 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbXD0Pwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:52:33 -0400
Date: Fri, 27 Apr 2007 11:21:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add sta item when changing WDS address
Message-ID: <20070427152115.GA6431@tuxdriver.com>
References: <1175011277.9282.8.camel@johannes.berg> <1177686772.3565.32.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1177686772.3565.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 27, 2007 at 05:12:52PM +0200, Johannes Berg wrote:
> On Tue, 2007-03-27 at 18:01 +0200, Johannes Berg wrote:
> > This patch adds a sta item for the new address when you change a WDS
> > link's address. If the sta item cannot be created return an error.
> 
> Anything wrong with this patch? :)

Hopefully nothing...I merged it as commit d80bb18ca3444520b465f3006bbb78837a5e28d9.

John
-- 
John W. Linville
linville@tuxdriver.com
