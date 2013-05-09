Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64377 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EIBhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 21:37:50 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm14so5672174wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 18:37:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368001971-11551-1-git-send-email-wilocity.git@gmail.com>
References: <1368001971-11551-1-git-send-email-wilocity.git@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 May 2013 11:37:29 +1000
Message-ID: <CAGRGNgUStj6ZKPj1fKV6uwHJUD+LU655zrje-R8=Ow+cHUHb_w@mail.gmail.com> (sfid-20130509_033754_623931_B7DE7376)
Subject: Re: [PATCH 1/3] wil6210: TCP/UDP checksum offloading support
To: wilocity.git@gmail.com
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wil6210@qca.qualcomm.com, Erez Kirshenbaum <erezk@wilocity.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erez,

Just a couple of notes on patch authorship and email addresses.

On Wed, May 8, 2013 at 6:32 PM,  <wilocity.git@gmail.com> wrote:
> From: Erez Kirshenbaum <erezk@wilocity.com>

In the other two patches, your email address is "erezk@wilocitycom" -
note the missing "."

> Add TCP/UDP checksum hardware offloading, configure hw and set the corresponding offloading bits in the
> DMA descriptors.
>
> Signed-off-by: Erez Kirshenbaum <erezk@wilocity.com>
> Signed-off-by: Wilocity Git <wilocity.git@gmail.com>

I assume you've read Documentation/SubmittingPatches, particularly the
section about signing your changes:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n297

The names in Signed-off-bys are expected to be real people or
permanent email addresses for teams. Given the name of the gmail
account, this appears to be just a email address you're sending
patches through. Is it monitored? Can you not send patches directly
from your "real" account?

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
