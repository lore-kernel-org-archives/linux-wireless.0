Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.253]:30441 "HELO
	nm16-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755629Ab1DGWTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 18:19:40 -0400
Message-ID: <73768.20361.qm@web161614.mail.bf1.yahoo.com>
Date: Thu, 7 Apr 2011 15:19:39 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Questions about rt2800usb
To: Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D9E316E.4000908@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I know from experience that the
> staging driver rt82860sta has been replaced by rt2800pci and
> I plan to push a patch deleting the driver from staging.
> 
> It appears that rt2870sta has been replaced by rt2800usb.
> Is that correct? If so, I will also include the deletion of
> that driver from staging in the patch.
> 
> I noticed that rt2870sta includes a few USB IDs not found
> in rt2800usb, namely:
> 
> 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.
> 
> Any reasons why these should not be included in rt2800usb?
> 
> Please let me know of any objections to removing those two
> staging drivers.

Here's my vote against removing the rt2870sta from staging. Some longstanding issues with latency and duplicate packets (rt307x) are persistent with rt2800usb, whereas rt2870sta works fine. 

my two cents

Walter
