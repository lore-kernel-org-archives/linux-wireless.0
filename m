Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752671AbdBIPH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 10:07:28 -0500
Date: Thu, 9 Feb 2017 16:02:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jeroen Roovers <jer@airfi.aero>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 3/3] rt2x00: remove queue_entry from skbdesc
Message-ID: <20170209150221.GA10105@redhat.com> (sfid-20170209_160732_071934_61023C46)
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
 <1486558291-1615-4-git-send-email-sgruszka@redhat.com>
 <CANCHnQq0111TX8psb4YizjSzOOUQSxj6Cf7OX8+L60J83wudsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANCHnQq0111TX8psb4YizjSzOOUQSxj6Cf7OX8+L60J83wudsQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 09, 2017 at 04:00:19PM +0100, Jeroen Roovers wrote:
> On 8 February 2017 at 13:51, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> > index 2233b91..22d1881 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
> > @@ -116,8 +116,6 @@ struct skb_frame_desc {
> >         __le32 iv[2];
> >
> >         dma_addr_t skb_dma;
> > -
> > -       struct queue_entry *entry;
> >  };
> >
> >  /**
> 
> That change needs this line removed above:
> 
>  * @entry: The entry to which this sk buffer belongs.

Thanks, I will fix comments when post next rt2x00 patch series.

Stanislaw
