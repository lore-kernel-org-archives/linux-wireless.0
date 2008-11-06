Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:33209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYKFPrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 10:47:04 -0500
Message-ID: <49131173.3010409@suse.de> (sfid-20081106_164708_868670_A2815AA6)
Date: Thu, 06 Nov 2008 16:46:59 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	James Ketrenos <jketreno@linux.intel.com>
Subject: Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de>
In-Reply-To: <49130E75.1000903@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frank Seidel schrieb:
> Ever suggestion is very appreciated.

My first search through the ipw2200 logs pointed
me to Davids last commit (521c4d96e0840ecce25b956e00f416ed499ef2ba)
and really after reverting it the problem disappeared here.
The patch from my last post was the smallest subset of
the revertion that still works for me here.
Any comments?
