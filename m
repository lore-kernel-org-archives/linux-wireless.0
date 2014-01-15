Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAONYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:24:49 -0500
Message-ID: <1389792284.4338.8.camel@jlt4.sipsolutions.net> (sfid-20140115_142452_446522_9D54A40B)
Subject: Re: [RFC 2/5] cfg80211: regulatory, introduce DFS CAC time
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 15 Jan 2014 14:24:44 +0100
In-Reply-To: <1389720570-2430-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182947_521176_14E85DB2)
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389720570-2430-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140114_182947_521176_14E85DB2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 18:29 +0100, Janusz Dziedzic wrote:
> Introduce DFS CAC time as a regd param, configured
> per REG_RULE and set per channel in cfg80211.

Why? :)

> + * @dfs_cac_ms: DFS CAC time in miliseconds

milli

johannes

