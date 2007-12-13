Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47087 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXLMSAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 13:00:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix rfkill radio LED
Date: Thu, 13 Dec 2007 18:58:46 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4760c3db.qCB1sy2b6EqODHqS%Larry.Finger@lwfinger.net> <200712131211.47867.mb@bu3sch.de> <47616AD2.8070108@lwfinger.net>
In-Reply-To: <47616AD2.8070108@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712131858.46552.mb@bu3sch.de> (sfid-20071213_180049_694598_48A8A113)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 December 2007 18:24:34 Larry Finger wrote:
> If (!built_in && !module)
> 	warn that the LED will not work.

This can not happen. b43 rfkill support is disabled, as it doesn't
make any sense without rfkill-input.

> In the version I sent you, the logic is:
> 
> if (!built_in) {
> 	load module
> 	if (err)
> 		print message that it will not work
> }

which is fine.

-- 
Greetings Michael.
