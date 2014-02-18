Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47235 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaBRUhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 15:37:23 -0500
Date: Tue, 18 Feb 2014 23:36:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Subject: Re: [PATCH 3/7] rtl818x: check for pci_map_single() success when
 initializing RX ring
Message-ID: <20140218203646.GQ26776@mwanda> (sfid-20140218_213730_926012_1FD10121)
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
 <20140218093135.GJ26776@mwanda>
 <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
 <20140218182714.GO26776@mwanda>
 <CAN8YU5P1-7TxvDFifEWPhGh3MbLP_DMJWS9Sbzte+TDcuELKLg@mail.gmail.com>
 <20140218192239.GP26776@mwanda>
 <CAN8YU5PQSNZHmEG6o2-uRQMo1G14M7ot-_KiHT2u=-4LCaremA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN8YU5PQSNZHmEG6o2-uRQMo1G14M7ot-_KiHT2u=-4LCaremA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 09:17:22PM +0100, Andrea Merello wrote:
> Ok, I will fix my patch in this way.
> I will resend it.
> Should I also rebase following patches in the patch serie and resent them also?
> 

Don't rebase if you don't have to.

Do you know how to use the In-Reply-To header so that the v2 patch will
show up in the thread?  There is an --in-reply-to option in git
send-email.

regards,
dan carpenter

