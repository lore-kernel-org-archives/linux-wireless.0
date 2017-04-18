Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45962 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755774AbdDRI4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 04:56:46 -0400
Message-ID: <1492505804.2472.4.camel@sipsolutions.net> (sfid-20170418_105806_501298_66FEE2D0)
Subject: Re: [PATCH V2 01/10] nl80211: add request id in scheduled scan
 event messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 18 Apr 2017 10:56:44 +0200
In-Reply-To: <1492085196-4574-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170413_140724_747022_27A2CF28)
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
         <1492085196-4574-2-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170413_140724_747022_27A2CF28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-13 at 13:06 +0100, Arend van Spriel wrote:
> For multi-scheduled scan support in subsequent patch a request id
> will be added. This patch add this request id to the scheduled
> scan event messages. For now the request id will always be zero.
> With multi-scheduled scan its value will inform user-space to which
> scan the event relates.

I've applied this, but please resend all of the remaining ones, even if
only patch 2 changes.

johannes
