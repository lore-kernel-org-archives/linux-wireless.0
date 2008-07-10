Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:59198 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYGJTv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 15:51:27 -0400
Date: Thu, 10 Jul 2008 15:51:23 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
Message-ID: <20080710195123.GN17936@ruslug.rutgers.edu> (sfid-20080710_215130_620693_0BD3F944)
References: <20080710152415.GK17936@ruslug.rutgers.edu> <1215706960.3483.37.camel@johannes.berg> <20080710193402.GL17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080710193402.GL17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Some more cleanups and fixes:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/v3-regdomain-patches/

I'll keep stashing them here.

I've confirmed this now lets the driver pass the regulatory_hint().
I still have to address your comments, Johannes. I'll do that next.

  Luis
