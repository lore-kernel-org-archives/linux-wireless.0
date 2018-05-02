Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750849AbeEBJlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 05:41:19 -0400
Date: Wed, 2 May 2018 11:39:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kofi Agor <nenekofi@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] rt2x00: check against flushing empty queue
Message-ID: <20180502093922.GA2677@redhat.com> (sfid-20180502_114347_054186_CD1AA016)
References: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
 <1525094357-24782-2-git-send-email-sgruszka@redhat.com>
 <CAOt++SdXt6YQKDZEdNxxEQOZ+sHyw2xjdUQm1DTGWdff-faJUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOt++SdXt6YQKDZEdNxxEQOZ+sHyw2xjdUQm1DTGWdff-faJUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, May 01, 2018 at 06:27:17AM -0600, Kofi Agor wrote:
> I haven't had a chance to test your patch yet, but does it resolve the tx
> queue flush issues? What platform are you developing/testing on?

I'm not sure about the issue, but most likely the patch
does not fix it. I tested the patch on RT3062 pcie device an
RT3071 usb dongle.

Regards
Stanislaw
