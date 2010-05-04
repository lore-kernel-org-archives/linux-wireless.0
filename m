Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0EDIXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 04:23:15 -0400
Subject: Re: [PATCH] cfg80211: Check for channel HT capabilities in an IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
	 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 10:23:11 +0200
Message-ID: <1272961391.3673.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 08:47 +0200, Benoit Papillault wrote:
> When configuring an HT IBSS, we need to check if the specified channel
> is capable of ht40+, ht40- or ht20.

These first two patches cannot be separate.

johannes

