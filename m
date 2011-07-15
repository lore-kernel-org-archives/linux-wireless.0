Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab1GOJpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:45:44 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-2-git-send-email-thomas@cozybit.com> (sfid-20110714_014631_631390_BB120B5C)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014631_631390_BB120B5C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:45:40 +0200
Message-ID: <1310723140.4164.10.camel@jlt3.sipsolutions.net> (sfid-20110715_114548_698329_AFE11ED0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:

> Based on Javier Cardona's "mac80211: Support beacon configuration via
> nl80211 for mesh interfaces", which never made it upstream.

Ok I don't get it -- this patchset seems to apply fine, so what part is
dependent on Javier's patches?

johannes

