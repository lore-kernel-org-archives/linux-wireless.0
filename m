Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48183 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbbFEClM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 22:41:12 -0400
From: David Lin <dlin@marvell.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Pete Hsieh" <peteh@marvell.com>, Chor Teck Law <ctlaw@marvell.com>
Subject: RE: [PATCH] mwlwifi: Initial submission of wireless driver to
 mainline
Date: Fri, 5 Jun 2015 02:41:09 +0000
Message-ID: <a244e659293f480fb9a53ee6a83f03bf@SC-EXCH02.marvell.com> (sfid-20150605_044117_935659_317BBD84)
References: <141c66f2950e4832a2bd99064db75970@SC-EXCH02.marvell.com>
 <557073D2.4080704@candelatech.com>
In-Reply-To: <557073D2.4080704@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 06/03/2015 09:55 PM, David Lin wrote:
> > Hi all,
> >
> > 	Herewith, I am submitting the Linux driver for WRT1900AC. The work
> > was initially developed as part of openwrt effort and maintained on
> > https://github.com/kaloz/mwlwifi, thanks to the host where it is
> > nurtured.
> >
> > 	Recently, I have also patched it to pass checkpatch.pl so that it can
> > be qualified for mainline.
> >
> > 	This is still work in progress, with 8864 chipset more mature and
> > tested, while 8897 for the similar use case is added recently. We will
> > continue to maintain and enhance it.
> >
> > We hope the community will welcome this initial submission!
> 
> Do you have any notes on what features this driver/NIC provides?
> 
> Does it require firmware, and if so, is source available?
> 
Support both 11b/g/a/n/ac AP mode, and STA mode (though the primary use case is AP). Driver matches most features in mac80211 and hostapd/supplicant. All basic securities mode have been validated.

Yes, it will require firmware microcode. Matching "binary" is reprovided as a separate .bin file(s) for each chip. Source codes of chip-dependent microcode will not be provided.

Thanks,
David
