Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932421AbeF2Hkg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:40:36 -0400
Message-ID: <1530258034.3481.2.camel@sipsolutions.net> (sfid-20180629_094039_991578_7AC34617)
Subject: Re: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 09:40:34 +0200
In-Reply-To: <20180619153950.28903-1-denkenz@gmail.com> (sfid-20180619_174004_371689_B903070F)
References: <20180619153950.28903-1-denkenz@gmail.com>
         (sfid-20180619_174004_371689_B903070F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-06-19 at 10:39 -0500, Denis Kenzior wrote:
> On pre-emption enabled kernels the following oops was being seen due to
> missing local_bh_disable/local_bh_enable calls.  mac80211 assumes that
> pre-emption is disabled in the data path.

Applied, but I've done some major edits to the commit message and added
a Fixes tag :)

johannes
