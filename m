Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40098 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbdFMGrt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 02:47:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 2/6] rsi: use enum for FSM states
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
        <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com>
Date: Tue, 13 Jun 2017 09:47:39 +0300
In-Reply-To: <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 2 Jun 2017 19:43:01 +0530")
Message-ID: <87lgowpeno.fsf@purkki.adurom.net> (sfid-20170613_085013_550839_82860382)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> Currently macros are used for FSM states. We will replace
> it with enum so that new state can be added easily without
> worrying about macro value.
>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

>From and Signed-off-by does not match (gmail.com vs redpinesignals.com).
I suggest that you add a separate From line to the commit log containing
redpinesignals.com, this way you can still submit patches via gmail.com.

Also your name in patchwork is not capitalised (patchwork is idiotic and
takes the name from patchwork user data and not from the patch):

      [1/6] rsi: add usb RS9113 chipset support                    2017-06-02 amit karwar  New
      [2/6] rsi: use enum for FSM states                           2017-06-02 amit karwar  New
      [3/6] rsi: Register interrupt handler before firmware load   2017-06-02 amit karwar  New
      [4/6] rsi: receive path enhancement for RS9113               2017-06-02 amit karwar  New
      [5/6] rsi: configure new boot parameters to device           2017-06-02 amit karwar  New
      [6/6] rsi: add tx frame for common device configuration      2017-06-02 amit karwar  New

To fix that could you please register to patchwork and capitalise your
name correctly? You have only one chance, patchwork doesn't allow users
edit the name afterwards, so don't do any typos :)

-- 
Kalle Valo
