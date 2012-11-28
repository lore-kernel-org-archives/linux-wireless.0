Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33101 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2K1XvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 18:51:01 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4746769wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 15:50:59 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 28 Nov 2012 15:50:59 -0800
Message-ID: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com> (sfid-20121129_005106_044845_EA483CA1)
Subject: ath9k_htc test release: please test
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've done an updated build of the ath9k_htc firmware images. I don't
currently have a HTC setup working so this is just a recompilation of
the current firmware.

http://dev.qca.qualcomm.com/~adrian/htc/20121128/

Please let me know if it works or doesn't work for you.

The specific two changes from Sujith's last release:

* Fix the TSF extension logic to correctly extend TSF from 32 bit to 64 bit;
* Update the embedded runtime OS code to the latest from Tensilica, in
preparation for open sourcing it;

I don't plan on fixing any bugs that already exist in the latest
ath9k_htc drop in the firmware git repository; I just want to check
that the build hasn't broken any existing behaviour (ie, "made things
worse.")

Thanks,


Adrian
