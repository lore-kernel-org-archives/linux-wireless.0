Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BNJzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 04:55:54 -0500
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 10:55:49 +0100
Message-ID: <1297677349.3785.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 08:16 -0800, Wey-Yi Guy wrote:
> remove plcp check for 3945, mark the function __maybe_unused

Why not remove the function instead?

johannes

