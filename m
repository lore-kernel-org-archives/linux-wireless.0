Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39927 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbYIOREM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 13:04:12 -0400
Date: Mon, 15 Sep 2008 10:04:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: sHittmeyer <hittmeyer@corscience.de>
CC: "linux-wireless@vger.kernel.org >> linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: Re: couldn't configure AR5416
Message-ID: <20080915170400.GE22572@tesla> (sfid-20080915_190416_258515_652CBE9F)
References: <48CE1DA2.2030406@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48CE1DA2.2030406@corscience.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 01:32:34AM -0700, sHittmeyer wrote:
> additionally I installed the actual "wireless tools for Linux"-Package
> in version 29 from
> http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html to be
> compatible with the
> new stack from compat-wireless-2.6-old.
> But trying to configure the device creates the following
> Kernel-error-message:

compat-wireless-old just got a new update, give that a shot. But also be
aware that compat-wireless-old is just that -- old so resources are
dedicated more to >= 2.6.27 right now; at least for ath9k.

  Luis
