Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933450AbeD1NHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Apr 2018 09:07:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from conn_owner
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
Date: Sat, 28 Apr 2018 16:07:09 +0300
In-Reply-To: <20180428014732.4018-1-andrew.zaborowski@intel.com> (Andrew
        Zaborowski's message of "Sat, 28 Apr 2018 03:47:32 +0200")
Message-ID: <87in8b8ooy.fsf@purkki.adurom.net> (sfid-20180428_150718_701077_8533F92E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> writes:

> Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
> NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
> from clients other than the connection owner set in the connect,
> authenticate or associate commands, if it was set.
>
> The main point of this check is to prevent chaos when two processes
> try to use nl80211 at the same time, it's not a security measure.
> The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
> START_AP/STOP_AP.

s-o-b missing.

-- 
Kalle Valo
