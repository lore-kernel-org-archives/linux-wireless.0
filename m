Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49677 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0AXKki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 05:40:38 -0500
Received: by ewy26 with SMTP id 26so1066361ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 02:40:37 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1264277460.13250.10.camel@maxim-laptop>
References: <1264277460.13250.10.camel@maxim-laptop>
Date: Sun, 24 Jan 2010 11:40:37 +0100
Message-ID: <2d0a357f1001240240k6e8eaefdm3633d3c6e5e30597@mail.gmail.com>
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

it is very helpful to give commit-id *and* commit-msg so that others
can follow more easily.
Which GIT repository (branch) is that?

Kind Regards,
- Sedat -

On Sat, Jan 23, 2010 at 9:10 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> I updated the kernel and lost connection to my WPA2
> AP. Strangely the WPA handshake completes, but DHCP not.
>
> I also unfortunately found that all that time I was using software
> encryption (this is iwl3945 loaded with swcrypto=1).
> Hardware encryption doesn't work ether and didn't work in the slightly
> older kernel (but it did work once, I sure)
>
> Now, the commit a6bae9e7ab19876a157c91019852395539e4f20e breaks software
> encryption, with behaviour like described above.
>
> Best regards,
> Maxim Levitsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
