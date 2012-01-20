Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1522 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2ATRFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 12:05:06 -0500
Message-ID: <4F199EAC.3050602@broadcom.com> (sfid-20120120_180511_209462_14CDD16C)
Date: Fri, 20 Jan 2012 18:04:44 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Milan Bouchet-Valat" <nalimilan@club.fr>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 doesn't work after suspend (brcmsmac on
 compat-wireless-next)
References: <1327067694.2590.6.camel@milan>
In-Reply-To: <1327067694.2590.6.camel@milan>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 02:54 PM, Milan Bouchet-Valat wrote:
> Hi!
> 
> With kernels 3.2 and 3.2.1, my Broadcom 4313 wireless card doesn't work
> after suspend: I need to reload the brcmsmac module by hand on resume.
> It worked fine with 3.1 kernels.
> 
> So I tried compat-wireless-next today (on Fedora 16), and it still
> doesn't work, though instead of oopses I get warnings. ;-)
> 
> The error messages are:
> [  165.612939] ieee80211 phy0: wl0: wlc_coreinit: ucode did not self-suspend!
> [  165.751978] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS
> and MI_MACSSPNDD is still not on.
> [  165.751989] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031,
> psm_brc 0x0000
> 
> (the two latter repeated many times, see attached dmesg.log)
> 
> Please ask for any details you may need (output of lspci -vnn is
> attached too, just in case).
> 
> 
> PS: Please keep me in CC, as I'm not subscribed to the list

I am not sure when compat-wireless-next was generated, but several
patches were made for suspend/resume. You also need bcma patches. Is
bcma included in the compat-wireless package.

Gr. AvS

