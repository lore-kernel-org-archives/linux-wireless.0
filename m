Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42981 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751868Ab2FQWFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 18:05:50 -0400
Message-ID: <1339970748.7577.1.camel@joe2Laptop> (sfid-20120618_000553_585406_B71A06D4)
Subject: Re: [PATCH] iwlwifi: fix Oops on reading debugfs log_event
From: Joe Perches <joe@perches.com>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 17 Jun 2012 15:05:48 -0700
In-Reply-To: <7841457.8s9HYuaGXa@penguin>
References: <7841457.8s9HYuaGXa@penguin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-17 at 22:58 +0200, Lekensteyn wrote:
> Before this patch, reading log_event would print the event log to syslog and
> crash if CONFIG_IWLWIFI_DEBUG was disabled (while CONFIG_IWLWIFI_DEBUGFS was
> enabled of course).

Make CONFIG_IWLWIFI_DEBUGFS dependent on CONFIG_IWLWIFI_DEBUG?


