Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36759 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdIAUHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 16:07:35 -0400
Received: by mail-pf0-f179.google.com with SMTP id r187so3269853pfr.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 13:07:35 -0700 (PDT)
Subject: Re: [PATCH 13/31] timer: Remove meaningless .data/.function
 assignments
To: Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1504222183-61202-1-git-send-email-keescook@chromium.org>
 <1504222183-61202-14-git-send-email-keescook@chromium.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a0462e18-5eae-95e0-21af-e9709729abb1@kernel.dk> (sfid-20170901_220755_128991_CF7ACE81)
Date: Fri, 1 Sep 2017 14:07:32 -0600
MIME-Version: 1.0
In-Reply-To: <1504222183-61202-14-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2017 05:29 PM, Kees Cook wrote:
> Several timer users needlessly reset their .function/.data fields during
> their timer callback, but nothing else changes them. Some users do not
> use their .data field at all. Each instance is removed here.

For amiflop:

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
