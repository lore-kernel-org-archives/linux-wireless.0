Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36099 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbeFEW7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 18:59:49 -0400
Received: by mail-pg0-f67.google.com with SMTP id m5-v6so1965734pgd.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2018 15:59:49 -0700 (PDT)
Date: Tue, 5 Jun 2018 15:59:45 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 0/6]  *** Add support for wifi QMI client driver ***
Message-ID: <20180605225944.GA194157@rodete-desktop-imager.corp.google.com> (sfid-20180606_005953_496628_05AA105C)
References: <20180605123304.31969-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123304.31969-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 05, 2018 at 06:03:04PM +0530, Govind Singh wrote:
> Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
> This module is responsible for communicating WLAN control messages to FW
> over QMI interface.
...

You still don't have the threading correct. Your patches should be
In-Reply-To the cover letter, so they get threaded by mail clients.

See, for instance, how the threaded view for your last version doesn't
show any of your patches:

https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg44199.html

(And Bjorn complained about this last time too.)

It looks like you're already using git-send-email, which should handle
this for you...just make sure you're sending all emails in one go (e.g.,
'git send-email <args> 0000-foo.patch 0001-bar.patch 0002-baz.patch
...').

Brian
