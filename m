Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38062 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab0EFWpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 18:45:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] ssb: resolve alternate SPROM offset for 14e4:4315
Date: Fri, 7 May 2010 00:44:56 +0200
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <4be24cdd.Yg6pH2Z4OwSotB+K%Larry.Finger@lwfinger.net> <201005061201.18469.mb@bu3sch.de> <4BE2C009.8020002@lwfinger.net> (sfid-20100506_131150_090575_629A6A99)
In-Reply-To: <4BE2C009.8020002@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005070044.56589.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 May 2010 15:11:37 Larry Finger wrote:
> Is it OK to read the chipcommon capabilities here?

Yeah. That register exists on all revisions.

Only add stuff to ssb_bus_scan that really _needs_ to be done that early.
Anything else should be done later.

-- 
Greetings, Michael.
