Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34972 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbbGGVYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 17:24:05 -0400
Received: by iecuq6 with SMTP id uq6so143364497iec.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 14:24:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>
References: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>
Date: Tue, 7 Jul 2015 23:24:04 +0200
Message-ID: <CACna6rz+=1Lg5OKmnLN3S+rx3bpiCkWhWshqvhz8jdxqH5J7bg@mail.gmail.com> (sfid-20150707_232410_632114_EBCABDEC)
Subject: Re: brcmfmac: one faulty "iw interface add" command breaks
 in-firmware BSS state
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 June 2015 at 21:59, Rafał Miłecki <zajec5@gmail.com> wrote:
> I've discovered some bug in brcmfmac & its BSS management. It was
> exposed by OpenWrt user space change ("fix") I introduced in:
> http://git.openwrt.org/?p=openwrt.git;a=commit;h=1cbb5e8de50457c1d9724ca75cc6815df5721289
> and it's related to the "interface add" command.

Did you try to fix it? I really would love to have upcoming OpenWrt CC
release with a working brcmfmac.
