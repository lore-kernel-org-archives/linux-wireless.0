Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4413 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1EXKlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 06:41:05 -0400
Message-ID: <4DDB8B32.9050809@broadcom.com> (sfid-20110524_124125_499048_77E8AE85)
Date: Tue, 24 May 2011 12:40:50 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
 <20110522122325.108b1c86@lxorguk.ukuu.org.uk>
 <4DD905CC.8040407@broadcom.com>
 <20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
 <4DDB622B.1050005@broadcom.com>
 <20110524104404.336c765f@lxorguk.ukuu.org.uk>
 <4DDB81FD.2020903@broadcom.com>
 <BANLkTinDvRx67vz8TfqPGod2X9QSctH0Zg@mail.gmail.com>
In-Reply-To: <BANLkTinDvRx67vz8TfqPGod2X9QSctH0Zg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 12:25 PM, Rafał Miłecki wrote:
> I'm out of topic, but you can take a look at drivers/ssb/pci.c
>
> We implement crc checksum here as well. The same will be soon needed
> for bcma (i've already done this locally).
>

Hi Rafał,

Couple of days ago I posted a patch for comments. In the commit message 
I referred to ssb having the same algorithm (identical crc table) as 
brcm80211. One of the reason for moving it to lib directory in the 
kernel tree. brcm80211, ssb, and bcma could use it.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


