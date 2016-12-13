Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50582 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752932AbcLMQUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:20:51 -0500
Message-ID: <1481646049.20412.43.camel@sipsolutions.net> (sfid-20161213_172413_750404_6A0F615B)
Subject: Re: [RFC V3 04/11] nl80211: add driver api for gscan notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2016 17:20:49 +0100
In-Reply-To: <1481543997-24624-5-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-5-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-12 at 11:59 +0000, Arend van Spriel wrote:
> The driver can indicate gscan results are available or gscan
> operation has stopped.

This patch is renumbering the previous patches' nl80211 API, which is
best avoided, even if I do realize it doesn't matter now. :)

Even here it's not clear how things are reported though. Somehow I
thought that gscan was reporting only partial information through the
buckets, or is that not true?

johannes
