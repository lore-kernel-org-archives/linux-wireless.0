Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50779 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab3JAQYZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 12:24:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 1 Oct 2013 09:23:56 -0700
Subject: RE: [PATCH v5 1/2] Bluetooth: btmrvl: add setup handler
Message-ID: <477F20668A386D41ADCC57781B1F70430F451FABE7@SC-VEXCH1.marvell.com> (sfid-20131001_182430_744279_E89EFB72)
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
 <18678858-E711-43E5-AFE6-E637D1CECFFB@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F44C59418@SC-VEXCH1.marvell.com>
 <DF6283E3-8476-400F-A230-CB7CA0F98564@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430F450779A4@SC-VEXCH1.marvell.com>
 <20130924193010.GA2584@x220.p-661hnu-f1>
 <477F20668A386D41ADCC57781B1F70430F45077E5B@SC-VEXCH1.marvell.com>
 <B3090D30-6F81-4E12-8F58-E650F77BB72E@holtmann.org>
 <20131001111309.GA19641@x220.p-661hnu-f1>
In-Reply-To: <20131001111309.GA19641@x220.p-661hnu-f1>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johan,

> Hi Marcel & Bing,
> 
> On Thu, Sep 26, 2013, Marcel Holtmann wrote:
> > >> You're right that we're missing the clearing of the HCI_SETUP flag
> > >> for such a scenario. Could you try the attached patch. It should
> > >> fix the
> > >
> > > We have tested your patch. Yes, it fixes the problem. Thanks!
> >
> > then lets get a proper version with full commit message explaining the
> > issue merged upstream. As I said, this is a real bug we need to fix.
> 
> I've just sent a new patch set titled "[PATCH 0/2] Bluetooth: Fix
> hci_dev_open race condition". Bing, could you please test this with your
> original setup so we ensure that the issue is still properly handled.

We tested this new patch set with our original setup and the issue is not seen.

Thanks,
Bing

