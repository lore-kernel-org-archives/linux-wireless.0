Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36805 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0CSTqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 15:46:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: do not read SPROM if it does not exist
Date: Fri, 19 Mar 2010 20:46:23 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
References: <4BA266FB.1080507@lwfinger.net> <1269025687-9817-1-git-send-email-linville@tuxdriver.com> <201003192041.47211.mb@bu3sch.de>
In-Reply-To: <201003192041.47211.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201003192046.23194.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 March 2010 20:41:47 Michael Buesch wrote:
> > +	if (bus->chip_rev >= 31)
> 
> This check is wrong.
> You need to check the chipcommon core revision. Not the chip revision.

Actually. All three checks in the patch are wrong. Not just in this place.

-- 
Greetings, Michael.
