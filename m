Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965011Ab3BMWwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 17:52:20 -0500
Message-ID: <1360795927.8868.30.camel@jlt4.sipsolutions.net> (sfid-20130213_235223_012342_89F9E939)
Subject: Re: [PATCH v2 1/3] mac80211: consolidate MBSS change notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 13 Feb 2013 23:52:07 +0100
In-Reply-To: <1360786461-30107-1-git-send-email-thomas@cozybit.com> (sfid-20130213_211534_268517_0A5CBD87)
References: <1360786461-30107-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130213_211534_268517_0A5CBD87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied all, removing the useless "return" in patch 2 and also adding a
proper return value there if beacon allocation fails.

johannes

