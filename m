Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45465 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753912AbYA0Mnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 07:43:47 -0500
Date: Sun, 27 Jan 2008 13:42:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Lars <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check
Message-ID: <20080127134252.776cebd6@morte> (sfid-20080127_124352_040226_7D7383C1)
In-Reply-To: <loom.20080126T193518-105@post.gmane.org>
References: <20080126040534.005e6736@morte>
	<200801261219.34805.mb@bu3sch.de>
	<loom.20080126T193518-105@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Jan 2008 19:40:14 +0000 (UTC)
Lars <Lars_Ericsson@telia.com> wrote:

> Hi,
> 
> I have spent some time debugging this problem from a different angle.
> 
> If you use a 'b/g' STA connecting to a 'b' AP you will run into this loop in a
> few seconds. What also happens is that the STA will try using 'g' speeds. That
> was the way I located the problem.

Thank you. I couldn't really figure out how to reproduce the bug.

> In other words, I do not think a WARN_ON is good solution.

Please could you try my 1/2 patch? In the meanwhile, I'll try to use your
information for more debugging.


--
Ciao
Stefano
