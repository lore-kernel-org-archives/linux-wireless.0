Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55630 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbeBWLZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 06:25:34 -0500
Message-ID: <1519385133.2231.7.camel@sipsolutions.net> (sfid-20180223_122537_644416_D3D2737B)
Subject: Re: [PATCH 3/4] mac80211: support fast-rx with incompatible PS
 capabilities when PS is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Fri, 23 Feb 2018 12:25:33 +0100
In-Reply-To: <20180223090606.55726-3-nbd@nbd.name>
References: <20180223090606.55726-1-nbd@nbd.name>
         <20180223090606.55726-3-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've applied 1 to mac80211, and 2/3 to mac80211-next, so please only
resend 4, unless you can convince me it's OK as is :-)

johannes
