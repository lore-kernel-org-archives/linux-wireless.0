Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaDVOpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:45:07 -0400
Message-ID: <1398177888.4211.8.camel@jlt4.sipsolutions.net> (sfid-20140422_164510_226602_129F99D1)
Subject: Re: [PATCH 01/12] mac80211: unify debug function
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:44:48 +0200
In-Reply-To: <45c72e6eaa809929a39e4ea4c253877e761f0aa3.1398055853.git.gamerh2o@gmail.com> (sfid-20140421_065453_516195_D11151D8)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <45c72e6eaa809929a39e4ea4c253877e761f0aa3.1398055853.git.gamerh2o@gmail.com>
	 (sfid-20140421_065453_516195_D11151D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:52 +0800, Zhao, Gang wrote:
> Both wiphy_debug() and wiphy_dbg() are used in mac80211. Change
> wiphy_debug() to wiphy_dbg() so all the debug messages can be
> dynamically controled whether to be generated or not.

But this means these messages go away by default now, why would we want
that?

johannes

