Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2K2Q6D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 11:58:03 -0500
Message-ID: <1354208333.3698.4.camel@dcbw.foobar.com> (sfid-20121129_175808_102790_48C68FC4)
Subject: Re: Marvell Avastar 88W8797 firmware
From: Dan Williams <dcbw@redhat.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"Shen, Jackey" <Jackey.Shen@amd.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 29 Nov 2012 10:58:53 -0600
In-Reply-To: <CAMXE1-qnix7STbjZtD69kzSTWGyv4LopM3Vc57hLyTLm0zsV9Q@mail.gmail.com>
References: <0C8FBB70FF40A94D98BE847F9C171A98033D23B0@SCYBEXDAG02.amd.com>
	 <477F20668A386D41ADCC57781B1F7043083BBD6CA7@SC-VEXCH1.marvell.com>
	 <CAMXE1-rrkh9qm5Hu7vwj3iTrkAg0uXQcU8ySMMBg5++ojJ==Ng@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F70430D1367C9ED@SC-VEXCH1.marvell.com>
	 <CAMXE1-qnix7STbjZtD69kzSTWGyv4LopM3Vc57hLyTLm0zsV9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 17:17 +0200, Andrei Emeltchenko wrote:
> Hi Bing,
> 
> On Tue, Nov 27, 2012 at 10:23 PM, Bing Zhao <bzhao@marvell.com> wrote:
> > Hi Andrei,
> >
> >> Do you mean here that 8797 might be connected via USB (currently I use
> >> 8787 via SDIO).
> >
> > For 8797, yes, you can connect it via USB interface.
> > If you have a reference adapter board from Marvell you can change some jumper settings to select either SDIO or USB.
> 
> Thanks for the info. But do I understand this right that firmware is
> not yet available?

If needed, I can submit it to the linux-firmware git tree, as I have
access to the Marvell Extranet, I have access to 87x7 firmware from the
Extranet, and the firmware license allows submission to linux-firmware
like we've done with a lot of other Marvell firmware.  However, it would
be best if either Bing could do this, or if Bing could indicate which
exact firmware version should be submitted to linux-firmware.

For example, I have access to these 8797 firmware versions:

USB/SDIO: 14.69.11.p142
USB-UART: 14.69.11.p97

Dan

