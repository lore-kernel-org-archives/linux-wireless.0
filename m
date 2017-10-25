Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47764 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdJYHR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 03:17:57 -0400
Message-ID: <1508915874.2421.0.camel@sipsolutions.net> (sfid-20171025_091808_419936_AF8B40EA)
Subject: Re: [PATCH] wireless-regdb: convert remaining values in mW to
 equivalent dBm
From: Johannes Berg <johannes@sipsolutions.net>
To: Ryan Mounce <ryan@mounce.com.au>, seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Wed, 25 Oct 2017 09:17:54 +0200
In-Reply-To: <20171025044539.17877-1-ryan@mounce.com.au> (sfid-20171025_064738_336787_9E6D9F12)
References: <20171025044539.17877-1-ryan@mounce.com.au>
         (sfid-20171025_064738_336787_9E6D9F12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-25 at 15:15 +1030, Ryan Mounce wrote:
> This patch converts the few remaining rules specified in mW to directly
> equivalent rules in dBm, to improve consistency of the regdb.

I don't know if this is the case for all cases here, but IMHO
consistency with the source documents (which are actually listed in
many of the entries you're changing), is more important than
consistency within the file.

johannes
