Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1KDQun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:50:43 -0400
Subject: Re: [PATCH v3] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320425330.3969.115.camel@jlt3.sipsolutions.net> (sfid-20111104_174857_877054_38C92B1F)
References: <CAMG6FYhbX+zKRw823RmPzwXqVzP7c+5W8pAaR4DGsOm0qnZGpA@mail.gmail.com>
	 (sfid-20111104_171212_230697_F4323BFB)  <1320425330.3969.115.camel@jlt3.sipsolutions.net>
	 (sfid-20111104_174857_877054_38C92B1F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 17:50:38 +0100
Message-ID: <1320425438.3969.116.camel@jlt3.sipsolutions.net> (sfid-20111104_175046_392816_1F215AA7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 17:48 +0100, Johannes Berg wrote:

> (I'm also thinking that maybe hashing the SSID into the tree was a bad
> idea?)

OTOH we don't have a choice unless we make the data structure more like
a hash table which seems more complex.

johannes

