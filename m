Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:43865 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbeFTQWq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 12:22:46 -0400
Received: by mail-oi0-f67.google.com with SMTP id t133-v6so117738oif.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 09:22:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180502093922.GA2677@redhat.com>
References: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
 <1525094357-24782-2-git-send-email-sgruszka@redhat.com> <CAOt++SdXt6YQKDZEdNxxEQOZ+sHyw2xjdUQm1DTGWdff-faJUw@mail.gmail.com>
 <20180502093922.GA2677@redhat.com>
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Wed, 20 Jun 2018 18:22:45 +0200
Message-ID: <CAKR_QVJUPOujZbo8N55JM8ZMDv3k2syrj2pBHwYJ60bPgHL2XA@mail.gmail.com> (sfid-20180620_182250_342849_C9456F4B)
Subject: Re: [PATCH 2/2] rt2x00: check against flushing empty queue
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kofi Agor <nenekofi@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

does it fix mt7620 bug?

On 02/05/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi
>
> On Tue, May 01, 2018 at 06:27:17AM -0600, Kofi Agor wrote:
>> I haven't had a chance to test your patch yet, but does it resolve the tx
>> queue flush issues? What platform are you developing/testing on?
>
> I'm not sure about the issue, but most likely the patch
> does not fix it. I tested the patch on RT3062 pcie device an
> RT3071 usb dongle.
>
> Regards
> Stanislaw
>
