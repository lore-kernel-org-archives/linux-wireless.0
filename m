Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNTyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:54:24 -0500
Message-ID: <1360871657.8210.14.camel@jlt4.sipsolutions.net> (sfid-20130214_205426_729027_EEB562AA)
Subject: Re: [PATCH v3 1/2] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 14 Feb 2013 20:54:17 +0100
In-Reply-To: <1360869614-29297-1-git-send-email-thomas@cozybit.com> (sfid-20130214_202134_927337_D6A0746D)
References: <1360869614-29297-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130214_202134_927337_D6A0746D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 11:20 -0800, Thomas Pedersen wrote:
> Previously, the entire mesh beacon would be generated each
> time the beacon timer fired. Instead generate a beacon
> head and tail (so the TIM can easily be inserted when mesh
> power save is on) when starting a mesh or the MBSS
> parameters change.
> 
> Also add a mutex for protecting beacon updates and
> preventing leaks.

Applied both, hopefully for good this time ;-)

johannes

