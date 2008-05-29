Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:32797 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYE2MP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 08:15:29 -0400
Received: by wr-out-0506.google.com with SMTP id c48so2238670wra.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 05:15:25 -0700 (PDT)
Message-ID: <43e72e890805290515o5417d3d1v25bf4efd30f040ba@mail.gmail.com> (sfid-20080529_141535_277175_C61B6C5B)
Date: Thu, 29 May 2008 17:45:25 +0530
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Waldemar Krzok" <waldemar@krzok.de>
Subject: Re: bug(?) compat_wireless
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805282351.44721.waldemar@krzok.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200805282351.44721.waldemar@krzok.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 3:21 AM, Waldemar Krzok <waldemar@krzok.de> wrote:
> Hi folks,
>
> I tried to install the newest compat_wireless driver for ZyDAS wifi adapter
> (buit-in USB wifi module) but without success. After downloading and
> unpacking the distribution 'make' terminated with error in file
> rtl8180_dev.c:249: "implicit declaration of function skb_get_queue_mapping".
> There is no declaration of this function neither in this file nor in the
> includes. Any hints?
>
> My config: Medion Laptop, Linux Suse 10.3 distribution,  kernel
> 2.6.22.5-31-default
>
> many thanks for your fb work && greetings from Berlin

Please try now.

  Luis
