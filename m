Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2DPVzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:55:19 -0400
Received: by pbcun15 with SMTP id un15so6850465pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 14:55:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334612679.5455.4.camel@dcbw.foobar.com>
References: <20120403160319.B26CF9D401E@zog.reactivated.net>
	<1334612679.5455.4.camel@dcbw.foobar.com>
Date: Mon, 16 Apr 2012 15:55:18 -0600
Message-ID: <CAMLZHHQ02Y0s7O4t7jKZZ+1H8SiyPGYxwLhdVHYSuf5aUA0fqw@mail.gmail.com> (sfid-20120416_235522_918684_1DB5D4AA)
Subject: Re: [RFC 4/4] libertas SDIO: convert to asynchronous firmware loading
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 3:44 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2012-04-03 at 17:03 +0100, Daniel Drake wrote:
>> Signed-off-by: Daniel Drake <dsd@laptop.org>
>
> Works on my standalone SD8686 dev board; though I do get:
>
> [32350.237619] libertas_sdio mmc0:0001:1: (unregistered net_device):
> 00:50:43:20:74:05, fw 9.70.3p36, cap 0x00000303
> [32350.239847] libertas_sdio mmc0:0001:1: (unregistered net_device):
> PREP_CMD: command 0x00a3 failed: 2
>
> where the "unregistered net_device" is a bit odd.  Perhaps we should fix
> that before the final series.

That actually appears the same before the patches too, it's been this
way ever since the cfg80211 port. Mind if I leave this issue for
another moment?

Thanks,
Daniel
