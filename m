Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38632 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932071AbeEWLYV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 07:24:21 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: RE: [EXT] Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device
 coredump
Date: Wed, 23 May 2018 11:24:13 +0000
Message-ID: <6c419785be0e4e89a62f3b81c36971ce@SC-EXCH02.marvell.com> (sfid-20180523_132430_197852_C14D0971)
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
        <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com>       <5AFC7E01.3070503@broadcom.com>
        <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com>
        <87po1mu7s2.fsf@purkki.adurom.net> <5B052248.5020805@broadcom.com>
 <87d0xmeqfw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d0xmeqfw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
> > On 5/23/2018 9:54 AM, Kalle Valo wrote:
> >> Ganapathi Bhat <gbhat@marvell.com> writes:
> >>
> >>> In V2:
> >>>
> >>>          return ret;
> >>>   }
> >>> +EXPORT_SYMBOL_GPL(mwifiex_send_cmd);
> >>>
> >>> Instead of exporting 'mwifiex_send_cmd' we can prepare a wrapper for
> >>> the command 'MWIFIEX_IFACE_WORK_DEVICE_DUMP' in mwifiex
> module. Let
> >>> me know if we can send a follow up.
> >>
> >> So what's the plan? Can I apply this patch or should I drop it?
> >
> > Sorry. Had to reply that earlier. When adding the export I figured it
> > might not be desirable. If Ganapathi can fix it with a follow up patch
> > that would ok, right?
>
> A follow up patch sounds good to me.
Sorry for confusions. I assume you will be margining the original patch and want me to send the follow-up right?
>
Regards,
Ganapathi
