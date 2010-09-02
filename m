Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0IBG51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 02:57:27 -0400
Received: by wyb35 with SMTP id 35so10248540wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Sep 2010 23:57:26 -0700 (PDT)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Vipin Mehta <vmehta@atheros.com>
Cc: <greg@kroah.com>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
Date: Thu, 02 Sep 2010 08:57:19 +0200
In-Reply-To: <1283381473-20415-1-git-send-email-vmehta@atheros.com> (Vipin
	Mehta's message of "Wed, 1 Sep 2010 15:51:13 -0700")
Message-ID: <87tym8vdio.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> "Vipin" == Vipin Mehta <vmehta@atheros.com> writes:

 Vipin> The patch adds support for the 802.11 chip, AR6003. It has been 
 Vipin> generated against the linux-next tree and is being targeted 
 Vipin> for the staging area.

 Vipin> A little bit about the chip and driver:
 Vipin> (Pls refer to http://wireless.kernel.org/en/users/Drivers/ath6kl
 Vipin> for details)

What is the relation to the (openmoko) ar6k driver for ar6000?

http://wireless.kernel.org/en/users/Drivers/ar6k

-- 
Bye, Peter Korsgaard
