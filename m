Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3GWMCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 08:02:47 -0400
Message-ID: <1374580962.8427.0.camel@jlt4.sipsolutions.net> (sfid-20130723_140250_860114_C6F2C9DC)
Subject: Re: [PATCH] mac80211: fix monitor interface suspend crash regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Date: Tue, 23 Jul 2013 14:02:42 +0200
In-Reply-To: <20130723115650.GB1687@redhat.com>
References: <20130723115650.GB1687@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-23 at 13:56 +0200, Stanislaw Gruszka wrote:
> My commit:
> 
> commit 12e7f517029dad819c45eca9ca01fdb9ba57616b
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Thu Feb 28 10:55:26 2013 +0100
> 
>     mac80211: cleanup generic suspend/resume procedures
> 
> removed check for deleting MONITOR and AP_VLAN when suspend. That can
> cause a crash (i.e. in iwlagn_mac_remove_interface()) since we remove
> interface in the driver that we did not add before.

Applied, thanks.

johannes

