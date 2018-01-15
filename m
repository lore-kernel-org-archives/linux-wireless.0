Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37270 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030453AbeAONPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 08:15:30 -0500
Message-ID: <1516022128.410.34.camel@sipsolutions.net> (sfid-20180115_141536_483529_8D63DDEA)
Subject: Re: [RFC v2 5/5] mac80211: Add support for tx_control_port
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 14:15:28 +0100
In-Reply-To: <20180110170938.2341-6-denkenz@gmail.com> (sfid-20180110_181002_615262_A9159F28)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-6-denkenz@gmail.com>
         (sfid-20180110_181002_615262_A9159F28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This looks straight-forward.

Again, question about which ethertype.

And you should probably add a define for 0x88c7 (and yeah, I'm willing
to take that through my tree)

johannes
