Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:36106 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757480AbcIXRnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 13:43:12 -0400
Message-ID: <1474738987.23838.13.camel@perches.com> (sfid-20160924_194315_523101_72C7B111)
Subject: Re: [PATCH 2/2] rtlwifi: Add explicit values to hw_variables enum
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Sat, 24 Sep 2016 10:43:07 -0700
In-Reply-To: <1474736239-9826-3-git-send-email-Larry.Finger@lwfinger.net>
References: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net>
         <1474736239-9826-3-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-09-24 at 11:57 -0500, Larry Finger wrote:
> The entries in this enum may be referenced in debug output. Adding explicit
> values simplifies the lookup.

A negative aspect to this style is forced renumbering
if a HW_VAR entry is inserted.

Is that possible?
