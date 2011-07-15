Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab1GOJ5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:57:51 -0400
Subject: Re: [PATCH 2/5] mac80211: correct mesh beacon head
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-3-git-send-email-thomas@cozybit.com> (sfid-20110714_014633_387436_20E7419F)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-3-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014633_387436_20E7419F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:57:47 +0200
Message-ID: <1310723867.4164.19.camel@jlt3.sipsolutions.net> (sfid-20110715_115753_089798_A974DE5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
> Supported Rates and DS Parameter elements go in the beacon head. Add
> these IEs when we initially construct the beacon.

This breaks mesh_plink_frame_tx() afaict.

johannes

