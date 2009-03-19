Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46043 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbZCSSd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 14:33:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 19:32:18 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200903191927.21868.mb@bu3sch.de>
In-Reply-To: <200903191927.21868.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903191932.18874.mb@bu3sch.de> (sfid-20090319_193331_029557_B404D8A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 March 2009 19:27:21 Michael Buesch wrote:
> This patch adds a workaround for the issue by just enabling the interrupt
> if debugging is disabled (by Kconfig or by modparam).

Of course I meant "just disabling the interrupt"

-- 
Greetings, Michael.
