Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:32905 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNTLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 15:11:39 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so8818604lbi.37
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2014 12:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141014185244.044b32bf@ilfaris>
References: <20141014185244.044b32bf@ilfaris>
Date: Tue, 14 Oct 2014 22:11:37 +0300
Message-ID: <CANUX_P1h9iXTv9y5f6GsY6q4QKv80dykQ4b+jmurGeEco3WksA@mail.gmail.com> (sfid-20141014_211142_777713_FA2736C3)
Subject: Re: iwlwif: traces and microcode sw error on 3.16.5, Intel
 Corporation Centrino Advanced-N 6205
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Julian Wollrath <jwollrath@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 14, 2014 at 7:52 PM, Julian Wollrath <jwollrath@web.de> wrote:
> Hi,
>
> I got several microcode sw errors and traces with 3.16.5. I attached
> the log and the output of lspci. In the traces it is mentioned, that
> the kernel version is 3.16.5+, but I can assure you, that it is plain
> 3.16.5 but somehow a false version got assigned, when I compiled from
> git.
>
> If you need more information, please do not hesitate to ask.
>

This is clearly a firmware issue - the firmware doesn't reply to a
command sent by the driver. Unfortunately, we don't have firmware
support for this type of devices.
