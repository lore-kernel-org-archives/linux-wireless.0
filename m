Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab2K3Lom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:44:42 -0500
Message-ID: <1354275905.10035.2.camel@jlt4.sipsolutions.net> (sfid-20121130_124448_535399_24FCCA93)
Subject: Re: [RFCv2 01/13] {nl,cfg,mac}80211: set beacon interval and DTIM
 period on mesh join
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 12:45:05 +0100
In-Reply-To: <1353701934-12752-2-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-2-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> Move the default mesh beacon interval and DTIM period to cfg80211 and
> make it accessible to nl80211. This enables setting both values when joining
> an MBSS.
> 
> NOTE: In a mesh with links in PS mode it is not advised to use the default
> parameters 1000:4, as these cause excessive buffering delays that exceed
> various timeouts (e.g. HWMP path request).

Looks fine, I think you should change the minimum BI to 10 or so though.

johannes


