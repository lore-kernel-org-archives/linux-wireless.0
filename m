Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55057 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2CSMkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 08:40:36 -0400
Received: by vbbff1 with SMTP id ff1so594663vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 05:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331888479.13561.22.camel@MacGyver>
References: <1331888479.13561.22.camel@MacGyver>
Date: Mon, 19 Mar 2012 18:10:36 +0530
Message-ID: <CAD2nsn2pOSh+4tBLeO95itMnbKdxYj1n8NT-ZB=LciUupYey1w@mail.gmail.com> (sfid-20120319_134040_278612_1E1CA640)
Subject: Re: ath9k state machine ?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: gavilanes@ismb.it
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 16, 2012 at 2:31 PM, Guido Gavilanes <gavilanes@ismb.it> wrote:
>
> Hello linux-wireless colleagues,
>
> Let me disturb you with a non-deep-in-the-code question...
> I am working on an specific application starting from ath9k driver.
> Basically I have to capture acks being used as triggers for other
> actions at user level, so it would be useful to know the "journey of a
> packet" through the driver (ath9k). Is this information available to
> you? (publicly available?) I have searched for a while without results;
> at the moment I am "blindly" working with a code analyzer through the
> driver source with little and slow results, but A description of the
> "state machine" would be more than useful; do you now where can I get
> something?

pls start from ath9k_tx in main.c and the interrupt path in
ath_tx_tasklet/ath_tx_edma_tasklet

>
> Thank you in advance for your help
> Guido
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
