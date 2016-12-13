Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50572 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753425AbcLMQUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:20:30 -0500
Message-ID: <1481645962.20412.41.camel@sipsolutions.net> (sfid-20161213_172414_030331_A1776E96)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2016 17:19:22 +0100
In-Reply-To: <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-12 at 11:59 +0000, Arend van Spriel wrote:
> This patch adds support for GScan which is a scan offload feature
> used in Android.

Found a few places with spaces instead of tabs as indentation, and
spurious braces around single-statement things, but other than that it
looks fine from a patch/nl80211 POV.

Haven't really looked into the details of gscan itself now though,
sorry.

There's a bit of a weird hard-coded restriction to 16 channels too,
that's due to the bucket map?

johannes
