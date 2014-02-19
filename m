Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56687 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaBSQiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:38:13 -0500
Received: by mail-pb0-f49.google.com with SMTP id up15so617687pbc.22
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 08:38:13 -0800 (PST)
Date: Wed, 19 Feb 2014 08:38:08 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 5/5] cfg80211: Enable GO operation on indoor channels
Message-ID: <20140219163806.GM14296@garbanzo.do-not-panic.com> (sfid-20140219_173824_117070_92006410)
References: <1392824377-18254-6-git-send-email-ilan.peer@intel.com>
 <1392824938-18439-1-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392824938-18439-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 05:48:58PM +0200, Ilan Peer wrote:
> Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
> iff there is a user hint indicating that the platform is operating in
> an indoor environment, i.e., the platform is a printer or media center
> device.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
