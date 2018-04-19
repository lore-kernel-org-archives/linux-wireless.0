Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750737AbeDSGAp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 02:00:45 -0400
Message-ID: <7162b267c0791b871dbd4e1b7b82e1ffaf91a6e5.camel@coelho.fi> (sfid-20180419_080048_862130_D4B355DA)
From: Luca Coelho <luca@coelho.fi>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        Scott Register <sreg@sreg.io>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Date: Thu, 19 Apr 2018 09:00:42 +0300
In-Reply-To: <03793285ba30a7767498feca8229418625dcf111.camel@coelho.fi>
References: <CANrGCJeTDQ1DTuum-asODLMoY4StspzukkWfTVtb6fJ+yHBGXg@mail.gmail.com>
         <CANUX_P0VoQHQ1iPsk_u1bZsEU1ny1SxwrZbQeSEBUVGyjKcyVQ@mail.gmail.com>
         <03793285ba30a7767498feca8229418625dcf111.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi 4.18rc1 SYNC TIME_QUOTA_CMD with fw 31
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-19 at 08:42 +0300, Luca Coelho wrote:
> On Wed, 2018-04-18 at 11:31 +0300, Emmanuel Grumbach wrote:
> > On Wed, Apr 18, 2018 at 5:47 AM, Scott Register <sreg@sreg.io>
> > wrote:
> > > 
> > > Hello,
> > > 
> > > After upgrading to 4.18rc1 iwlwifi is printing a FW error. There
> > > was a
> > > previous thread with a similar
> > > issue but they seemed to resolve it with a ucode update. I think
> > > I'm
> > > running a newer FW and
> > > am still having an issue. 4.13 works--I haven't gone any higher
> > > so
> > > far.
> > 
> > Please download the firmware from
> > https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware
> > .g
> > it/plain/iwlwifi-8265-36.ucode
> > This should fix your problem.
> 
> Yeah, it should work with FW 36.  But if there really is something in
> 4.18 that breaks support on 31, we should either fix it or make sure
> we
> don't even try to load this old firmware.

Hmmm, you (and I) obviously meant 4.17-rc1. ;)

--
Cheers,
Luca.
