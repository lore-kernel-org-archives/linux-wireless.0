Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:32895 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdH3TLc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:11:32 -0400
Received: by mail-wm0-f52.google.com with SMTP id r202so3670059wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:11:31 -0700 (PDT)
Subject: Re: [PATCH 13/30] brcmfmac: Clarify if using braces.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-14-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <78917893-6b3d-9cfc-1f32-e27226ae6189@broadcom.com> (sfid-20170830_211135_911653_32653151)
Date: Wed, 30 Aug 2017 21:11:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-14-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Whilst this if () statement is technically correct, it lacks clarity.

I don't see the unclarity here. In my opinion people reading the code 
should have a good level in C language and a decent level of curiosity 
when they come across a function/macro like skb_queue_walk().

Regards,
Arend
