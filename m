Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58134 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759180AbYH2VXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 17:23:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 4/4 v2] cfg80211.h: add support for letting the user set the regulatory domain
Date: Fri, 29 Aug 2008 23:22:31 +0200
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
References: <1220043811-9860-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1220043811-9860-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808292322.31719.mb@bu3sch.de> (sfid-20080829_232327_159870_23587BA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 August 2008 23:03:31 Luis R. Rodriguez wrote:
> +		.cmd = NL80211_CMD_REQ_SET_REG,
> +		.doit = nl80211_ask_set_reg,

Shouldn't we adjust the function name, too?

-- 
Greetings Michael.
