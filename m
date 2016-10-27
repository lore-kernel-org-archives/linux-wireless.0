Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34619 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935043AbcJ0Sfk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 14:35:40 -0400
Received: by mail-pf0-f170.google.com with SMTP id n85so22292401pfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 11:35:40 -0700 (PDT)
Date: Thu, 27 Oct 2016 11:35:37 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2 1/5] mwifiex: remove redundant condition in main
 process
Message-ID: <20161027183536.GA28717@localhost> (sfid-20161027_203543_151809_EEA84280)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2016 at 02:42:39PM +0530, Amitkumar Karwar wrote:
> This condition while calling mwifiex_check_ps_cond() is redundant.
> The function internally already takes care of it.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Same as v1

You've omitted the Reviewed-by tags from v1:

Reviewed-by: Brian Norris <briannorris@chromium.org>
