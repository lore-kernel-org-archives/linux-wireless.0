Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43020 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933744AbeFQU2a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 16:28:30 -0400
Message-ID: <1529267306.3070.0.camel@sipsolutions.net> (sfid-20180617_222841_598052_B80970B0)
Subject: Re: [PATCH v3 0/5] use BIT_ULL for NL80211_STA_INFO_* attribute
 types
From: Johannes Berg <johannes@sipsolutions.net>
To: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, devel@driverdev.osuosl.org
Date: Sun, 17 Jun 2018 22:28:26 +0200
In-Reply-To: <1529229951-17730-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180617_120607_305286_FD9A7637)
References: <1529229951-17730-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180617_120607_305286_FD9A7637)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-06-17 at 13:05 +0300, Omer Efrat wrote:
> 
> Note: The following patch series only does some code clean up.
> The previous versions mentioned a bug fix but it appears as a mix up
> with some local changes because NL80211_STA_INFO_TID_STATS value actually
> equals 31.

Interesting. Thanks for checking!

johannes
