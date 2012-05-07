Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2EGTth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 15:49:37 -0400
Received: by pbbrp8 with SMTP id rp8so7089631pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 12:49:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120507.115228.1171858914064928263.davem@davemloft.net>
References: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
 <20120506.145304.1998242927519675381.davem@davemloft.net> <20120507081411.GA19002@aemeltch-MOBL1>
 <20120507.115228.1171858914064928263.davem@davemloft.net>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 7 May 2012 16:49:16 -0300
Message-ID: <CAMOw1v474CTigis2xNBF53YP-NMt2XmMR_zvqNAeN8kmEQjxGA@mail.gmail.com> (sfid-20120507_214951_465058_10B273C2)
Subject: Re: [PATCH] Bluetooth: Fix coding style
To: David Miller <davem@davemloft.net>
Cc: andrei.emeltchenko.news@gmail.com, dh.herrmann@googlemail.com,
	gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 7, 2012 at 12:52 PM, David Miller <davem@davemloft.net> wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
> Date: Mon, 7 May 2012 11:14:13 +0300
>
>> If you think that Documentation/CodingStyle is a crap why don't you send a
>> patch to fix it?
>
> The same reason I don't go try and fix broken networking RFCs.
>
> Documents are never are the final verdict on anything, there will
> always be areas where such documents are wrong and common sense should
> prevail.

Then we go and fix the docs. This is how they work, or at least should.

Doing so also means we don't create our own rules and impose them on
others, like happened some time ago
(https://lkml.org/lkml/2012/4/16/473).

Regards,
Lucas De Marchi
