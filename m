Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33100 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2DPUaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:30:08 -0400
Received: by dake40 with SMTP id e40so7376903dak.11
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 13:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334597520.10194.37.camel@dcbw.foobar.com>
References: <20120403160104.D765B9D401E@zog.reactivated.net>
	<1334597520.10194.37.camel@dcbw.foobar.com>
Date: Mon, 16 Apr 2012 14:30:07 -0600
Message-ID: <CAMLZHHTJ_tX+4D=LRyn6gbNKHeRNW5_j4YS4_qz5MDMROYiCiA@mail.gmail.com> (sfid-20120416_223017_415513_E645FEBE)
Subject: Re: [RFC 1/4] libertas: Firmware loading simplifications
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 11:32 AM, Dan Williams <dcbw@redhat.com> wrote:
> I think the reprogram functionality was intended for the school server
> use-case.  I was advocating for a standalone firmware flashing tool for
> this anyway (and had written a Python-based one back in 2007) but if
> OLPC doesn't support the school server stuff anymore, we can safely
> remove the flashing capability.

Yes, unfortunately those efforts are long-dead as it didn't succeed.

Thanks
Daniel
