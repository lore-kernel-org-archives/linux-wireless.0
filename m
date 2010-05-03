Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58345 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab0ECX4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 19:56:49 -0400
Received: by pwj9 with SMTP id 9so1515585pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 16:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <w2z43e72e891005031654rea8e3628i6906895089bd6b03@mail.gmail.com>
References: <87och0j7jj.fsf@purkki.valot.fi> <w2q43e72e891005031610uf6b912aduf271b0a97933d68a@mail.gmail.com>
	<w2z43e72e891005031654rea8e3628i6906895089bd6b03@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 May 2010 16:56:28 -0700
Message-ID: <j2s43e72e891005031656wcc8c6db3y2f9dce7961f23b2e@mail.gmail.com>
Subject: Re: HT rate warning with openwrt AP using wireless-compat and ath9k
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 3, 2010 at 4:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, May 3, 2010 at 4:10 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> 0x7b
>
> Actually 0x7b fits 0x7f if the rate was marked as an HT rate by
> hardware (0x80) so technically it could have been an HT rate marked as
> 0x7b and that is why you get the warning. So I wonder what hardware
> rate 0xfb should be mapping to (0x7b | 0x80).

What I'm saying is I don't think you will hit that debug print I
pointed out, and we need to figure out what 0xfb or 0x7b should map
too as hardware seems to be spewing it out on RX'd frames.

  Luis
