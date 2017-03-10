Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753120AbdCJI46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 03:56:58 -0500
Message-ID: <1489136175.3038.2.camel@sipsolutions.net> (sfid-20170310_095701_587048_1854E973)
Subject: Re: [PATCH] ath6kl: Remove old 802.11a-only channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostyslav Khudolii <rkhudolii@airtame.com>, kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
        Attila Sukosd <attila@airtame.com>
Date: Fri, 10 Mar 2017 09:56:15 +0100
In-Reply-To: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com> (sfid-20170310_094952_335386_C643D863)
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
         (sfid-20170310_094952_335386_C643D863)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-10 at 09:49 +0100, Rostyslav Khudolii wrote:
> Channels 34/38/42/46 can only be used for compatibility with
> old devices sold in Japan. Modern products, such as AR6003/AR6004
> don't support these channels.
> Keeping them in the upstream is error prone and requires full
> network stack support.

Seems pointless. Nothing in the network stack really cares much about
the channel numbers, so what exactly does this improve?

johannes
