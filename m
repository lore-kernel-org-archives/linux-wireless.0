Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:58574 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751957AbXLWKjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 05:39:53 -0500
Date: Sun, 23 Dec 2007 11:36:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] mac80211: fix sta_info locking
Message-ID: <20071223113635.062e3ec5@morte> (sfid-20071223_103956_941287_3BC4AA37)
In-Reply-To: <20071223111806.663f3f4e@morte>
References: <20071223033633.710907923@polimi.it>
	<20071223050844.4e6b8c13@morte>
	<1198395536.6630.13.camel@johannes.berg>
	<20071223111806.663f3f4e@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Dec 2007 11:18:06 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> I now removed the lock, rebuilt my quilt tree, rebuilt mac80211 and I can't
> reproduce it. I think that could have been my fault, I should have did
							  ^^^^ must, I meant.


-- 
Ciao
Stefano
