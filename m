Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3BLKXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 05:23:36 -0500
Message-ID: <1360664610.8178.6.camel@jlt4.sipsolutions.net> (sfid-20130212_112339_369434_CFEEAC39)
Subject: Re: [PATCH] mac80211: allow driver to be stateless wrt. SMSP
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 12 Feb 2013 11:23:30 +0100
In-Reply-To: <1360580237-6149-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_115726_883650_F746ECF9)
References: <1360580237-6149-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130211_115726_883650_F746ECF9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 11:57 +0100, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Bail out if no update is made to the SMPS state. This
> allows the driver to avoid duplicating the state.

Applied.

johannes

