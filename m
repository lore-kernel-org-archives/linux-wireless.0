Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3JaQql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:46:41 -0400
Message-ID: <1383237995.14302.7.camel@jlt4.sipsolutions.net> (sfid-20131031_174644_312951_BC2057D5)
Subject: Re: [PATCH 4/5] cfg80211: DFS check chandef usable before CAC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 31 Oct 2013 17:46:35 +0100
In-Reply-To: <1382984824-3729-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131028_192722_332408_7BDE0DA9)
References: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1382984824-3729-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131028_192722_332408_7BDE0DA9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 19:27 +0100, Janusz Dziedzic wrote:

> +/**
> + * cfg80211_chandef_dfs_usable - checks if chandef is usable and we can
> + * start CAC on such chandef.

The short kernel-doc description can't span multiple lines

johannes

