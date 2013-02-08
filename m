Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab3BHJKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:10:19 -0500
Message-ID: <1360314615.29851.7.camel@jlt4.sipsolutions.net> (sfid-20130208_101207_138063_C33097D3)
Subject: Re: [PATCH] mac80211: Add the DS Params for mesh to every band
From: Johannes Berg <johannes@sipsolutions.net>
To: Emanuel Taube <emanuel.taube@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 10:10:15 +0100
In-Reply-To: <1360156637-30926-1-git-send-email-emanuel.taube@gmail.com> (sfid-20130206_141753_283286_A01AF301)
References: <1360156637-30926-1-git-send-email-emanuel.taube@gmail.com>
	 (sfid-20130206_141753_283286_A01AF301)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 14:17 +0100, Emanuel Taube wrote:
> There seems to be no reason, why it has to be limited to 2.4 GHz.

Applied. This was changed (in -2012?) I think, before DS params were
only used on 2.4

johannes

