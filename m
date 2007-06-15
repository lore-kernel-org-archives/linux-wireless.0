Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42140 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753331AbXFONau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2007 09:30:50 -0400
Date: Fri, 15 Jun 2007 15:30:53 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] conserve stack space due to padding
Message-ID: <20070615153053.37aaffb0@griffin.suse.cz>
In-Reply-To: <1181805971.9058.14.camel@johannes.berg>
References: <1181805971.9058.14.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 Jun 2007 09:26:11 +0200, Johannes Berg wrote:
> This patch reorders some fields in struct ieee802_11_elems to save 17*7
> or 17*3 bytes (on 64/32-bit machines respectively) stack space in a few
> functions.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Jiri Benc <jbenc@suse.cz>

-- 
Jiri Benc
SUSE Labs
