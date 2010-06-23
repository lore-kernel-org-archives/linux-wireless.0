Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:33957 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0FWUsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 16:48:13 -0400
Received: by pxi7 with SMTP id 7so428862pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 13:48:13 -0700 (PDT)
Message-ID: <4C227340.2000302@lwfinger.net>
Date: Wed, 23 Jun 2010 15:49:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Recent results with BCM4312 on Netbook
References: <4C20D884.3010501@lwfinger.net> <AANLkTikjzHcT9L472CFJ2LKtOiEUIk2S78_S_s-IxHjl@mail.gmail.com> (sfid-20100623_004823_485864_1D673701) <4C22014A.3000102@bu3sch.de>
In-Reply-To: <4C22014A.3000102@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2010 07:42 AM, Michael Büsch wrote:
> Please note that there were some rewrites recently in the kernel
> DMA subsystem. b43 does now use the generic DMA interface, which
> should work on all busses. I would not rule out an error in
> that area, though it's unlikely.

I don't think that is a problem. None of my other 3 systems developed an
error with that change. In addition, the Netbook started working as
mysteriously as it had failed earlier. I just love intermittent cases. ;-)

Larry
