Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BOTYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:24:53 -0500
Message-ID: <1360956286.15040.21.camel@jlt4.sipsolutions.net> (sfid-20130215_202458_667302_48E44D75)
Subject: Re: [PATCH] mac80211: Fix incorrect use of STA_PR_FMT in trace
 points
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Feb 2013 20:24:46 +0100
In-Reply-To: <1360955748-26608-1-git-send-email-seth.forshee@canonical.com>
References: <1360955748-26608-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 13:15 -0600, Seth Forshee wrote:
> Several tracepoints are using STA_PR_FMT where STA_PR_ARG should be
> used, resulting in messages like "phy0 sta:ARG TYPE NOT FIELD BUT 1".
> Change these to STA_PR_ARG.

Heh, I'd seen them but never found the cause ... thanks, applied!

johannes

