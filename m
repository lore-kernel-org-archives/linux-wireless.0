Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60022 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbbBWLvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 06:51:00 -0500
Message-ID: <1424692257.2782.7.camel@sipsolutions.net> (sfid-20150223_125111_890391_98A8D648)
Subject: Re: [PATCH] mac80211: rx: check for the skb_copy_bits() return value
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Feb 2015 12:50:57 +0100
In-Reply-To: <1424200323-5488-1-git-send-email-kda@linux-powerpc.org> (sfid-20150217_200808_846005_9A0EF378)
References: <1424200323-5488-1-git-send-email-kda@linux-powerpc.org>
	 (sfid-20150217_200808_846005_9A0EF378)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You fail to provide a useful commit log explaining why this change
should be done? Given that all the code already has the necessary
checks, these calls can never return non-zero, so this seems pointless?

johannes


