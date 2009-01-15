Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52829 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZAOPdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 10:33:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: Lots of minstrel WARN_ONS with current -git
Date: Thu, 15 Jan 2009 16:33:11 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1231973480.5147.2.camel@brick>
In-Reply-To: <1231973480.5147.2.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901151633.11794.mb@bu3sch.de> (sfid-20090115_163405_976875_C4DE365F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 23:51:20 Harvey Harrison wrote:
> Seeing lots of these WARN_ONS with current -git.  Known issue?
> 
> b43 hardware.
> 
> [41850.615621] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0x92/0x3c0()

I think that happens, if you have a b-only AP.

-- 
Greetings, Michael.
