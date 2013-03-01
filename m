Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CASqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 13:46:08 -0500
Message-ID: <1362163556.24973.10.camel@jlt4.sipsolutions.net> (sfid-20130301_194612_780104_CB9C42E2)
Subject: Re: [PATCH 0/7] mac80211: improve and consolidate minstrel rate
 control
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Date: Fri, 01 Mar 2013 19:45:56 +0100
In-Reply-To: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130301_183748_203358_A3BE35F2)
References: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20130301_183748_203358_A3BE35F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 18:37 +0100, Thomas Huehn wrote:
> This patch series merges functions, macros and sampling improvements from
> minstrel_ht into minstrel. It adds several improvements to the rate control.  

Generally, please CC me on this address rather than my @intel.com one
(for patches anyway) -- it tends to fit my workflow better and make it
less likely I'll lose a patch :-)

johannes

