Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45452 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1EJT7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:59:51 -0400
Received: by bwz15 with SMTP id 15so5140333bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 12:59:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305057374-9875-1-git-send-email-greearb@candelatech.com>
References: <1305057374-9875-1-git-send-email-greearb@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 10 May 2011 12:59:30 -0700
Message-ID: <BANLkTinngCnqYOtbt8+X8u2xMp5kApOvwA@mail.gmail.com> (sfid-20110510_215954_760007_217D2F00)
Subject: Re: [RFC ] wireless: Support can-scan-one logic.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See inline

On Tue, May 10, 2011 at 12:56 PM, <greearb@candelatech.com> wrote:
>
> +
> +       /*
> +         printk("start_sw_scan, can_scan_one: %i  n_channels: %i\n",
> +         local->scan_req->can_scan_one, local->scan_req->n_channels);
> +         WARN_ON(!local->scan_req->can_scan_one);
> +       */

Remove the debug print?

> +
> +               /* If one sta is associated, we don't want another to start
> +                * scanning on all channels, as that will interfere with the
> +                * one already associated.
> +                */

Comment style is wrong.

>
> +                       /* Special hack:  channel -1 means 'scan only active
> +                        * channel if any VIFs on this device are associated
> +                        * on the channel.
> +                        */

Same.

>
> +       /* If at least one VIF on this hardware is already associated, then
> +        * only scan on the active channel.
> +        */

Same.

Dan
