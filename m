Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60412 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752702AbdBIOvK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 09:51:10 -0500
Message-ID: <1486649944.17671.2.camel@sipsolutions.net> (sfid-20170209_155113_489013_6A9BBD17)
Subject: Re: [PATCH] mac80211: fix CSA in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: linux-wireless@vger.kernel.org,
        Piotr Gawlowicz <gawlowicz@tkn.tu-berlin.de>,
        =?UTF-8?Q?Miko=C5=82aj?= Chwalisz <chwalisz@tkn.tu-berlin.de>
Date: Thu, 09 Feb 2017 15:19:04 +0100
In-Reply-To: <1486564325-14251-1-git-send-email-koen.vandeputte@ncentric.com> (sfid-20170208_154234_171021_DE7F57CE)
References: <1486564325-14251-1-git-send-email-koen.vandeputte@ncentric.com>
         (sfid-20170208_154234_171021_DE7F57CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-08 at 15:32 +0100, Koen Vandeputte wrote:
> Add the missing IBSS capability flag during capability init as it
> needs
> to be inserted into the generated beacon in order for CSA to work.
> 

Applied, thanks.

johannes
