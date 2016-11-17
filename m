Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47476 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754613AbcKQRYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:24:16 -0500
Message-ID: <1479393551.1463.11.camel@sipsolutions.net> (sfid-20161117_182434_930758_A754226C)
Subject: Re: [RFC 0/5] nl80211: add support for g-scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 17 Nov 2016 15:39:11 +0100
In-Reply-To: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-17 at 13:18 +0000, Arend van Spriel wrote:
> Android employs a Wifi-HAL layer in its wireless frame. It basically
> abstracts dealing with netlink messages from the framework. For some
> features it employs nl80211 vendor commands. The goal I set myself is
> to be able to have a generic nl80211 Wifi-HAL implementation. One of
> the features currently requiring the vendor commands is g-scan. We
> can only guess what the 'g' stands for ;-) This series converts the
> vendor command api into common nl80211 api.

Hehe :)
We also have gscan API. If you're interested, you can see it here:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/tree/drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.h#n96


> Before making an attempt to explain more about the g-scan
> functionality first this. While I am still testing the driver
> implementation resulting in numerous questions Dmitry send the email
> below to bring a related discussion to the table..eh.. the linux-
> wireless list. This is probably a good thing as anyone can dive in
> and share their thoughts.


Yeah. How does this overlap? Have you looked at it already?

johannes
