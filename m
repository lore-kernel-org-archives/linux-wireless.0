Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13406 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYJVVhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 17:37:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 14:37:10 -0700
Date: Wed, 22 Oct 2008 07:36:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: remove struct regdom hinting
Message-ID: <20081022143659.GL6190@tesla> (sfid-20081022_233719_243117_EEE1C10C)
References: <1224585042.5521.7.camel@johannes.berg> <20081022113950.GE6190@tesla> <1224701496.30459.50.camel@johannes.berg> <20081022122914.GH6190@tesla> <1224703869.30459.63.camel@johannes.berg> <20081022124139.GK6190@tesla> <1224704622.30459.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224704622.30459.71.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:43:42PM -0700, Johannes Berg wrote:
> On Wed, 2008-10-22 at 05:41 -0700, Luis R. Rodriguez wrote:
> 
> > Well, the alpha2 hint from country IE we'd built it from the IE
> > and then try call an rd hint routine, I take it now it would be the new
> > struct one. 
> 
> No, we'll have to add a new one for that

OK fair enough. Should make it easier to read too.

  Luis
