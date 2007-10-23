Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46494 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXJWKzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 06:55:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IkHPa-0006rb-Du
	for linux-wireless@vger.kernel.org; Tue, 23 Oct 2007 10:55:02 +0000
Received: from dhcp09.algebra.tuwien.ac.at ([128.131.43.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 10:55:02 +0000
Received: from preining by dhcp09.algebra.tuwien.ac.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 10:55:02 +0000
To: linux-wireless@vger.kernel.org
From: Norbert Preining <preining@logic.at>
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using =?utf-8?b?bWFjODAyMTFfbGVkcw==?=
Date: Tue, 23 Oct 2007 10:46:55 +0000 (UTC)
Message-ID: <loom.20071023T104428-443@post.gmane.org> (sfid-20071023_115514_360755_07F5F340)
References: <47164DA9.3050001@telenet.be>  <9f50a7a00710222311u7ae17958w596c3d579fb31536@mail.gmail.com> <1193120114.3069.256.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@...> writes:
aven't have enough time to review this patch these days. Will
> try to do it next week. But any test are always welcome!

I would like to, is there a way to patch this into the git sources?

I am running 2.6.23 with latest iwlwifi git sources.

I patched the git sources and started compiling with -DCONFIG_IWLWIFI_LEDS=y but
the compile boiled out with:
/src/wlan/iwlwifi/foo/compatible/iwl3945-base.c:6218: error: implicit
declaration of function 'ieee80211_get_assoc_led_name'
(and some more warnings).

Is there anything I can do to test it?

Best wishes

Norbert

