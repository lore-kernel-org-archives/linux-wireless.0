Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3DJLS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 07:18:58 -0400
Message-ID: <1365592730.8388.8.camel@jlt4.sipsolutions.net> (sfid-20130410_131903_325225_3E45EF71)
Subject: Re: [Patch] mac80211: SMPS for AP Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivekananda Holla <vivekanandah@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 10 Apr 2013 13:18:50 +0200
In-Reply-To: <516541FD.9050109@posedge.com>
References: <516541FD.9050109@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 16:12 +0530, Vivekananda Holla wrote:
> patch for SMPS mode. after discussion, setting the IEEE80211_TX_RC_USE_RTS_CTS flag for first rate if dynamic SMPS is on in the receiving station

Please line-break your description and remove all the discussion-related
stuff etc. from the commit log -- see
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches

Also, it should set the flag depending on the MCS ... Please try to
understand what you're actually doing and trying to do before submitting
random patches. It's not an effective use of my time to be reviewing
patches if you don't know what you're doing.

johannes

