Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43916 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYFJHZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 03:25:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K5yE2-0000BH-Ni
	for linux-wireless@vger.kernel.org; Tue, 10 Jun 2008 07:25:02 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 07:25:02 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 07:25:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: hostap kernel lockup?
Date: Tue, 10 Jun 2008 08:24:44 +0100
Message-ID: <g2la7s$g8r$1@ger.gmane.org> (sfid-20080610_092510_274128_D29554D5)
References: <g2760n$7f0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-testers@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sitsofe Wheeler wrote:

> hostap_pci on a 32bit x86 machine seems to be unstable under load in
> next-20080604. Using iperf between a wired machine on the other side of
> the AP and the hostap box makes hostap output the message
> wifi0: SW TICK stuck? bits=0x0 EvStat=8000 IntEn=e09f
> before things slowly grind to a halt in a lockup that seemingly needs a
> sysrq reboot. This problem seems to be reproducible every time but does
> not happen with Ubuntu's 2.6.22 kernel.

This issue seems to be happening at least as far back as 2.6.22 vanilla with
the config on http://sucs.org/~sits/test/config-2.6.22.txt although things
always seem to be recoverable. Sometimes the system will recover after the
lockup with a message like:
Clocksource tsc unstable (delta = 9377016871 ns)
Time acpi_pm clocksource has been installed.
Unfortunately even after if this does happen supsequent runs can still
freeze things to the extent that caps lock will stop responding. It can get
to the stage where screen updates in X only seem to happen when a key is
pressed on the keyboard. 

-- 
Sitsofe | http://sucs.org/~sits/

