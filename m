Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44379 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2LAObb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 09:31:31 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so570015eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2012 06:31:29 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: ath9k_htc test release: please test
Date: Sat, 1 Dec 2012 15:31:25 +0100
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>
References: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com>
In-Reply-To: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212011531.25832.chunkeey@googlemail.com> (sfid-20121201_153134_801160_905B11F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 November 2012 00:50:59 Adrian Chadd wrote:
> Hi all,
> 
> I've done an updated build of the ath9k_htc firmware images. I don't
> currently have a HTC setup working so this is just a recompilation of
> the current firmware.
> 
> http://dev.qca.qualcomm.com/~adrian/htc/20121128/
> 
> Please let me know if it works or doesn't work for you.

Thanks! It seems to work/hold.

Can you please bump the version

old:
[   26.106713] ath9k_htc 1-10:1.0: ath9k_htc: FW Version: 1.3
new:
[16308.270828] ath9k_htc 1-10:1.0: ath9k_htc: FW Version: 1.3

> The specific two changes from Sujith's last release:
> * Update the embedded runtime OS code to the latest from Tensilica, in
> preparation for open sourcing it;
Hey, I like to hear more about that. :)

Regards,
	Chr
