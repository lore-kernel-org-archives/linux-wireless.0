Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42399 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbcI3LTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 07:19:10 -0400
Message-ID: <1475234346.17481.38.camel@sipsolutions.net> (sfid-20160930_131913_498262_F956D121)
Subject: Re: [PATCH] cfg80211: Add support for static WEP in the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 30 Sep 2016 13:19:06 +0200
In-Reply-To: <20160922201650.16722-1-luca@coelho.fi>
References: <20160922201650.16722-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-22 at 23:16 +0300, Luca Coelho wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Add support for drivers that implement static WEP internally, i.e.
> expose connection keys to the driver in connect flow and don't
> upload the keys after the connection.
> 
Applied.

johannes
