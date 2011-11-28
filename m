Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52080 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1K1U5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 15:57:02 -0500
Received: by yenl6 with SMTP id l6so3291344yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 12:57:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111124210222.GA9929@jm.kir.nu>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322062858-15276-6-git-send-email-mcgrof@qca.qualcomm.com> <20111124210222.GA9929@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 15:56:41 -0500
Message-ID: <CAB=NE6U3HkrZ6m23sjB_tcKjwOSXwYrfH0mUnnaTEukc2DLfDQ@mail.gmail.com> (sfid-20111128_215707_541344_EDF46307)
Subject: Re: [RFC 5/5] wireless: annotate drivers that do not support NL80211_TX_POWER_REG
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 24, 2011 at 4:02 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Nov 23, 2011 at 10:40:58AM -0500, Luis R. Rodriguez wrote:
>> brcm80211, iwmc3200wifi and mwifiex lack support for
>> NL80211_TX_POWER_REG.
>
>> diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
>> +     case NL80211_TX_REG:
>
> That would benefit from a test run with a compiler..

Thought I had.. sorry, dropping this in favor for a reg_notifier()
approach instead.

  Luis
