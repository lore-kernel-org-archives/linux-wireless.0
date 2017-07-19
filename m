Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34838 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbdGSUJi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 16:09:38 -0400
Received: by mail-pg0-f43.google.com with SMTP id v190so4688979pgv.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2017 13:09:38 -0700 (PDT)
Date: Wed, 19 Jul 2017 13:09:34 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: add tdls uapsd support module parameter
Message-ID: <20170719200933.GA126381@google.com> (sfid-20170719_220942_188823_70DCCB03)
References: <1500446187-8034-1-git-send-email-huxinming820@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500446187-8034-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 19, 2017 at 06:36:27AM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Add module parameter to control tdls uapsd support, which is
> default disabled.

Why default disabled, when it looks like it used to be on by default?
