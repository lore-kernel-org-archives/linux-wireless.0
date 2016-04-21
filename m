Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36124 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbcDUNTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 09:19:46 -0400
Received: by mail-oi0-f45.google.com with SMTP id x201so82739254oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2016 06:19:46 -0700 (PDT)
Date: Thu, 21 Apr 2016 08:19:38 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Maximilian Engelhardt <engelhardt@perisens.de>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
Message-ID: <20160421131938.GA95003@ubuntu-hedt> (sfid-20160421_151957_936411_AD7B3C1D)
References: <1958820.LBuzOElZFT@perisens15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1958820.LBuzOElZFT@perisens15>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2016 at 08:03:16PM +0200, Maximilian Engelhardt wrote:
> Hi,
> 
> In Europe ETSI standardized the used for short range devices (SRD) [1] in ETSI 
> EN 300 440-1 [2].
> According to this standard generic use equipment is allowed to transmit in the 
> frequency range form 5725 MHz to 5875 MHz with a maximum output power of 
> 25 mW e.i.r.p. This generic allocation also allows transmission of 802.11 
> devices.
> 
> [3] has a list of countries and their status about the implementation of the 
> SRD frequency bands. For the 5 GHz band this can be seen on page 38 in the 
> paragraph ANNEX 1 and the entry Annex j.
> 
> Attached is a patch that adds the 5 GHz SRD band to db.txt for Germany.
> 
> If it is acceptable I can provide a patch adding the 5 GHz SRD band for the 
> other countries listed in [3].

The changes seem okay as far as I can tell. You do need to include your
signed-off-by tag on the patch however, see
https://git.kernel.org/cgit/linux/kernel/git/sforshee/wireless-regdb.git/tree/CONTRIBUTING.

Thanks,
Seth
