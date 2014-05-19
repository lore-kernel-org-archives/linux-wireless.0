Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33482 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbaESNVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 09:21:48 -0400
Message-ID: <1400503214.4273.0.camel@jlt4.sipsolutions.net> (sfid-20140519_152152_017847_7C8D24C2)
Subject: Re: [PATCH] cfg80211: add documentation for max_num_csa_coutners
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, andrei.otcheretianski@intel.com
Date: Mon, 19 May 2014 14:40:14 +0200
In-Reply-To: <1400174289-22108-1-git-send-email-luca@coelho.fi>
References: <1400174289-22108-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 20:18 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Move the comment in the structure to a description of the
> max_num_csa_counters field in the docbook area.
> 
> This fixes a warning when building htmldocs (at least):
> 
>  Warning(include/net/cfg80211.h:3064): No description found for parameter 'max_num_csa_counters'

Applied (with the subject typo fixed)

johannes

