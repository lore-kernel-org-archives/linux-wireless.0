Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47992 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753396AbcJZGJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:09:39 -0400
Message-ID: <1477462177.4059.19.camel@sipsolutions.net> (sfid-20161026_080944_283307_276FFF66)
Subject: Re: [PATCH 2/2] mac80211: use inline kernel-doc for struct
 ieee80211_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@intel.com>, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Date: Wed, 26 Oct 2016 08:09:37 +0200
In-Reply-To: <1477054644-5945-2-git-send-email-jani.nikula@intel.com>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
         <1477054644-5945-2-git-send-email-jani.nikula@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
> It's easier to manage the kernel-doc for the fields when they
> documentation is next to the field.

Ok, actually, this doesn't apply. Perhaps I'll look into scripting this
kind of conversion.

johannes
