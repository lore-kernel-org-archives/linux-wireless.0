Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:35103 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab1D2UEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:04:42 -0400
Received: by mail-ey0-f173.google.com with SMTP id 6so1415887eyb.32
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:04:29 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: add debugfs entries for dtim_interval and
 beacon_interval
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303028447-16264-1-git-send-email-eliad@wizery.com>
References: <1303028447-16264-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:04:25 +0300
Message-ID: <1304107465.12586.158.camel@cumari> (sfid-20110429_220445_209042_6557B31E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-17 at 11:20 +0300, Eliad Peller wrote:
> +static ssize_t beacon_interval_read(struct file *file, char __user *user_buf,
> +                                   size_t count, loff_t *ppos)
> +{
> +       struct wl1271 *wl = file->private_data;
> +       u8 value;
> +
> +       if (wl->conf.conn.wake_up_event == CONF_WAKE_UP_EVENT_BEACON|| 

I also added one extra space before || here to avoid a checkpatch.pl
warning.

-- 
Cheers,
Luca.

