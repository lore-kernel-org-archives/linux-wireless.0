Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:50608 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbXLTUzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 15:55:36 -0500
Date: Thu, 20 Dec 2007 21:51:50 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: mac80211: rc algos broken
Message-ID: <20071220215150.3ffcafbe@morte> (sfid-20071220_205551_279230_0902915F)
In-Reply-To: <200712202035.45909.mb@bu3sch.de>
References: <200712202020.51320.mb@bu3sch.de>
	<200712202035.45909.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 20 Dec 2007 20:35:45 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> Grepping the code it seems that nobody is ever calling
> ieee80211_rate_control_register(). I guess that it kind of a fatal problem. ;)

Indeed. Really sorry for the breakage, I'm fixing that in a bit.


--
Ciao
Stefano
