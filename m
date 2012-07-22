Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52054 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2GVW5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 18:57:33 -0400
Received: by lbbgm6 with SMTP id gm6so7236181lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 15:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <64da8470918769de8cac7e449876961b@fileserver.lan>
References: <64da8470918769de8cac7e449876961b@fileserver.lan>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 23 Jul 2012 08:57:11 +1000
Message-ID: <CAGRGNgWPHv95Q4NPY06HSrhHf83T5iX3HiHukHeGu4tiP_nM_A@mail.gmail.com> (sfid-20120723_005743_644212_3AAE89A2)
Subject: Re: [Patch] on typo in compat-wireless-2012-05-08/include/linux/compat-2.6.28.h
To: Mijzelf@live.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mijzelf,

On Mon, Jul 23, 2012 at 5:05 AM, Mijzelf <Mijzelf@live.com> wrote:
> diff a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
> 30c30
> < #if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) ||
> defned(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
> ---
>>
>> #if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) ||
>> defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)

This isn't how you submit patches.

You should read Documentation/SubmittingPatches in your kernel tree.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
