Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37240 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0AQQlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 11:41:11 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/7] b43: N-PHY: implement TX PHY cleanup and setup
Date: Sun, 17 Jan 2010 17:41:00 +0100
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	=?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <op.u6oef6cl9lhzdc@linux-g0th.site> <69e28c911001170837u4ea715ddn4a8e2001f6c1acc3@mail.gmail.com>
In-Reply-To: <69e28c911001170837u4ea715ddn4a8e2001f6c1acc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001171741.02945.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 January 2010 17:37:29 Gábor Stefanik wrote:
> While you are at it, why aren't you programming these table writes?
> The table handling functions are AFAIK already in place...

Because we like small patches.
Please do _not_ increase the patchsize.

-- 
Greetings, Michael.
