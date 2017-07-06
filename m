Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38026 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbdGFHiN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 03:38:13 -0400
Received: by mail-it0-f54.google.com with SMTP id k192so109422863ith.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 00:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a496cdaa-41f3-53e1-bb4f-2843d5bd8b12@lwfinger.net>
References: <a496cdaa-41f3-53e1-bb4f-2843d5bd8b12@lwfinger.net>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 6 Jul 2017 10:38:11 +0300
Message-ID: <CANUX_P3E9OASgfHykWsFjN1ii__sM=-8wWKr+6+rMk6GP2utvg@mail.gmail.com> (sfid-20170706_093901_047913_5AD77E35)
Subject: Re: Command equivalent in iw
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 6, 2017 at 5:51 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> Someone using the rtlwifi code that is posted at GitHub wants to know the iw equivalent of "iwpriv wlan0 bandcfg" to limit the wireless interface to 802.11b, 802.11g, or 802.11n. I only use simple iw commands, and I could not answer the question.

This seems to be a private IOCTL and I can't find the code for that
handler in the kernel today. Even in wireless extensions..
I am not aware of something like this with iw today.

In iwlwifi we have module parameter for this since this should really
be used seldom.
