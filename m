Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab1GOJ6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:58:35 -0400
Subject: Re: [PATCH 3/5] mac80211: Ext. Supported Rates go in mesh beacon
 tail
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-4-git-send-email-thomas@cozybit.com> (sfid-20110714_014634_757340_52A97A31)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-4-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014634_757340_52A97A31)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:58:32 +0200
Message-ID: <1310723912.4164.20.camel@jlt3.sipsolutions.net> (sfid-20110715_115837_611104_EED28EB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
> Give mesh beacon a tail and maintain Extended Supported Rates IE here.
> Reorder construction of mesh beacon frame so it looks like:
> 
> head | tail | mesh IEs | vendor IEs
> 
> mesh IEs include dynamic elements which must be updated on each beacon.

This is stupid, you're introducing a bug you fix in patch 4/5.

johannes

