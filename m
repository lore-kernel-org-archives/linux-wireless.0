Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54300 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3JALNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:13:19 -0400
Date: Tue, 1 Oct 2013 14:13:09 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <20131001111309.GA19641@x220.p-661hnu-f1> (sfid-20131001_131323_869499_AD87A11C)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
 <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com>
 <20130924193010.GA2584@x220.p-661hnu-f1>
 <477F20668A386D41ADCC57781B1F70430F45077E5B@SC-VEXCH1.marvell.com>
 <B3090D30-6F81-4E12-8F58-E650F77BB72E@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B3090D30-6F81-4E12-8F58-E650F77BB72E@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel & Bing,

On Thu, Sep 26, 2013, Marcel Holtmann wrote:
> >> You're right that we're missing the clearing of the HCI_SETUP flag for
> >> such a scenario. Could you try the attached patch. It should fix the
> > 
> > We have tested your patch. Yes, it fixes the problem. Thanks!
> 
> then lets get a proper version with full commit message explaining the
> issue merged upstream. As I said, this is a real bug we need to fix.

I've just sent a new patch set titled "[PATCH 0/2] Bluetooth: Fix
hci_dev_open race condition". Bing, could you please test this with your
original setup so we ensure that the issue is still properly handled.

Johan
