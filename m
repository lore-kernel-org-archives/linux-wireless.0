Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:59173 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYDXLYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 07:24:54 -0400
Received: by wa-out-1112.google.com with SMTP id m16so5339160waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2008 04:24:51 -0700 (PDT)
Message-ID: <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com> (sfid-20080424_132527_332991_4EBA2A2B)
Date: Thu, 24 Apr 2008 14:24:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Priit Laes" <plaes@plaes.org>
Subject: Re: [PATCH] iwlwifi: Select also LEDS_TRIGGERS.
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
	reinette.chatre@intel.com
In-Reply-To: <1209033767.1368.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209033767.1368.3.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shouldn't be this already covered by MAC80211_LEDS

	depends on IWL4965
 	select MAC80211_LEDS
 	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	select IWLWIFI_LEDS

On Thu, Apr 24, 2008 at 1:42 PM, Priit Laes <plaes@plaes.org> wrote:
> Following patch fixes build for me..
>
