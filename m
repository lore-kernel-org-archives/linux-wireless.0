Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39946 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752676AbcJDG4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 02:56:25 -0400
Message-ID: <1475564182.5324.0.camel@sipsolutions.net> (sfid-20161004_085629_154499_BD7E8FE6)
Subject: Re: [PATCH 2/3] mac80211: multicast to unicast conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: "M. Braun" <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Oct 2016 08:56:22 +0200
In-Reply-To: <7ff03edc-2c24-9038-6e69-0cd3456c8e24@fami-braun.de>
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
         <1474821596-12155-3-git-send-email-michael-dev@fami-braun.de>
         <1475220560.17481.7.camel@sipsolutions.net>
         <7ff03edc-2c24-9038-6e69-0cd3456c8e24@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-04 at 06:36 +0200, M. Braun wrote:
> Am 30.09.2016 um 09:29 schrieb Johannes Berg:
> > 
> > > 
> > > +static ssize_t ieee80211_if_fmt_unicast(
> > > +	const struct ieee80211_sub_if_data *sdata, char *buf,
> > > int
> > > buflen)
> > 
> > That's a very ... unusual way to break the lines here
> 
> it is the same style as used in debugfs_netdev.c for other
> attributes,
> see e.g. ieee80211_if_fmt_tsf, ieee80211_if_parse_tsf.
> 

Fair enough, I didn't check. Maybe I'll change it all wholesale at some
other point then.

johannes
