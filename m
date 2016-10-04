Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:42093 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbcJDEhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 00:37:11 -0400
Subject: Re: [PATCH 2/3] mac80211: multicast to unicast conversion
To: Johannes Berg <johannes@sipsolutions.net>
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
 <1474821596-12155-3-git-send-email-michael-dev@fami-braun.de>
 <1475220560.17481.7.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <7ff03edc-2c24-9038-6e69-0cd3456c8e24@fami-braun.de> (sfid-20161004_063715_618896_2DD926D8)
Date: Tue, 4 Oct 2016 06:36:55 +0200
MIME-Version: 1.0
In-Reply-To: <1475220560.17481.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 30.09.2016 um 09:29 schrieb Johannes Berg:
>> +static ssize_t ieee80211_if_fmt_unicast(
>> +	const struct ieee80211_sub_if_data *sdata, char *buf, int
>> buflen)
> 
> That's a very ... unusual way to break the lines here

it is the same style as used in debugfs_netdev.c for other attributes,
see e.g. ieee80211_if_fmt_tsf, ieee80211_if_parse_tsf.

Michael
