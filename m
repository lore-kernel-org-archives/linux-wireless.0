Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1CATIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 14:08:01 -0500
Subject: Re: [PATCH] lib-average: Make config option selectable
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bruno Randolf <br1@einfach.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1299006185.28897.5.camel@marge>
References: <1299006185.28897.5.camel@marge>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 20:07:59 +0100
Message-ID: <1299006479.6015.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 20:03 +0100, Michael Buesch wrote:
> Make CONFIG_AVERAGE selectable for out-of-tree users
> such as compat-wireless.

Is that really necessary? We haven't typically done this, and often just
shipped the code in compat instead?

johannes

