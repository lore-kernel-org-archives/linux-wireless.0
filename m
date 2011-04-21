Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63305 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1DUTwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 15:52:54 -0400
Received: by qyk7 with SMTP id 7so55793qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 12:52:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1104212222470.9925@mail.embedromix.ro>
References: <alpine.LFD.2.00.1104212222470.9925@mail.embedromix.ro>
Date: Thu, 21 Apr 2011 21:52:53 +0200
Message-ID: <BANLkTikdkprc3kZbTwrPBOU1RCU2_qi33w@mail.gmail.com>
Subject: Re: [PATCH] Ralink 3090 must load rt3090.bin firmware, not rt2860.bin.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 21, 2011 at 9:25 PM, Catalin(ux) M. BOIE
<catab@embedromix.ro> wrote:
> Hello.
>
> Please apply it.

NACK.

1) You didn't send this patch inline
2) There is no such thing as different firmware filenames
for the rt2800pci drivers. Ralink did release some stuff under different names,
but they are basically different versions of the same file.

So you can rename your rt3090.bin file to rt2860.bin file, and both rt2860 and
rt3090 devices can operate using it.

Ivo
