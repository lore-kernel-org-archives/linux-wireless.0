Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33744 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932123AbcLLKBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 05:01:48 -0500
Received: by mail-io0-f178.google.com with SMTP id d9so161040600ioe.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2016 02:01:47 -0800 (PST)
Received: from mail-io0-f178.google.com (mail-io0-f178.google.com. [209.85.223.178])
        by smtp.gmail.com with ESMTPSA id l73sm15577115ioe.1.2016.12.12.02.01.47
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2016 02:01:47 -0800 (PST)
Received: by mail-io0-f178.google.com with SMTP id a81so154411986ioe.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2016 02:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8E332BC1-F05E-4771-ABA4-BD6C59449125@holtmann.org>
References: <20161212002911.5541-1-andrew.zaborowski@intel.com> <8E332BC1-F05E-4771-ABA4-BD6C59449125@holtmann.org>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Mon, 12 Dec 2016 11:01:45 +0100
Message-ID: <CAOq732Lvqez5mNne9YAk8aTrZyAQsxxL6pSwD9EkB4V0t2mLrg@mail.gmail.com> (sfid-20161212_110152_498754_AEAADC19)
Subject: Re: [PATCH] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 December 2016 at 08:21, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Disconnect or deauthenticate when the owning socket is closed if this
>> flag is supplied to CMD_CONNECT or CMD_AUTHENTICATE.  This may be used
>> to ensure userspace daemon doesn't leave an unmanaged connection behind.
>
> I think you have a typo here. The CMD_AUTHENTICATE should be CMD_ASSOCIATE?

Good point, let me change this and resend.

Best regards
