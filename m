Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52452 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab3C3PRW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 11:17:22 -0400
Received: from romuald.bergerie (unknown [88.178.86.202])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 6EDEF9400BC
	for <linux-wireless@vger.kernel.org>; Sat, 30 Mar 2013 16:17:14 +0100 (CET)
Message-ID: <515701F7.8040800@bergerie> (sfid-20130330_161734_166801_D800D71B)
Date: Sat, 30 Mar 2013 16:17:11 +0100
From: Vincent <vincent.stehle@laposte.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix uninitialized variable
References: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net> <1364462493.8312.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364462493.8312.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2013 10:21 AM, Johannes Berg wrote:
> No, you're wrong, presumably misled by the compiler.

Ah! Right; I see it now. Sorry for the noise.

V.
