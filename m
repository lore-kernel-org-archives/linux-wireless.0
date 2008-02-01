Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:50481 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755650AbYBAPDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 10:03:35 -0500
Date: Fri, 1 Feb 2008 15:57:22 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211 rate control: fix section mismatch
Message-ID: <20080201155722.7e6f0d9a@morte> (sfid-20080201_150344_163452_24BD7FB5)
In-Reply-To: <1201804317.4149.34.camel@johannes.berg>
References: <1201804317.4149.34.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 31 Jan 2008 19:31:57 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> When the rate control algorithms are built-in, their exit
> functions can be called from mac80211's init function so
> they cannot be marked __exit.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


-- 
Ciao
Stefano
