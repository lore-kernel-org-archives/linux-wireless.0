Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbYGPQbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 12:31:38 -0400
Subject: Re: [GIT PATCH] rfkill fixes, set 2
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 12:29:24 -0400
Message-Id: <1216225764.21973.8.camel@localhost.localdomain> (sfid-20080716_183158_253497_33D1E174)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-15 at 16:32 -0300, Henrique de Moraes Holschuh wrote:
> Here is a small set of fixes for rfkill, mostly stuff I noticed while I
> was working on other patches that I will send in for RFC and testing,
> later.
> 
> It does include the documentation change requested by Ivo that makes
> rfkill_force_state non-optional where applicable (devices that get
> external state changes).
> 
> Shortlog:
> 
> Henrique de Moraes Holschuh (4):
>       rfkill: document rfkill_force_state as required
>       rfkill: fix led-trigger unregister order in error unwind
>       rfkill: document the rfkill struct locking
>       rfkill: mutex fixes
> 
> Please consider for merging for 2.6.26, as they are fixes and not
> enhancements.  Ivo, please be specially hard on the last patch, I did
> test it here, but locking is always tricky...

If you do really mean 2.6.26, that's out already so you'd want to send
the patches to stable@ as well.  But I assume you mean 2.6.27, right?

Dan

> Patches based on wireless-testing master.
> 

