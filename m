Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:63372 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZKJPjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 10:39:31 -0500
Received: by fxm21 with SMTP id 21so141707fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 07:39:36 -0800 (PST)
Message-ID: <4AF98934.6070507@lwfinger.net>
Date: Tue, 10 Nov 2009 09:39:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Marcel Holtmann <marcel@holtmann.org>, bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 0/6] rtl8187se: Initial introduction of driver
References: <4af8a56a.fCJY51VFS93aEZ0t%Larry.Finger@lwfinger.net> <1257845103.26914.5.camel@violet> <20091110133433.GB12682@tuxdriver.com>
In-Reply-To: <20091110133433.GB12682@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2009 07:34 AM, John W. Linville wrote:
> On Tue, Nov 10, 2009 at 10:25:03AM +0100, Marcel Holtmann wrote:
>> Hi Larry,
>>
>>> Patches to introduce a driver for the RTL8187SE PCI-based device.
>>>
>>> Note: This driver is only compile-tested and will require more work
>>> for it to be useful. I'm posting now to let others know what I have done.
>>>
>>> I have applied for an account at kernel.org. If my request is approved, I
>>> plan to establish an rtl8187se git tree.
>>>
>>> Patch 1/6: Create file rtl8187se.h
>>> Patch 2/6: Create file rtl8187se_dev.c
>>> Patch 3/6: Create file rtl8187se_rtl8225.c
>>> Patch 4/6: Create file rtl8187se_rtl8225.h
>>> Patch 5/6: Modify file rtl818x.h
>>> Patch 6/6: Modify Kconfig and Makefile for rtl8187se
>>
>> so personally I don't think the split in a per file commit is helpful at
>> all. It adds no real value to the tree. For review and working around
>> the size limit of vger.kernel.org it is fine, but for the final merge I
>> prefer that all files are added in one commit.
> 
> Yes, I agree.

No problem. In fact, there is one gigantic patch on my system that I split
before the send. I will keep them split while the review/testing phase is
happening, then combine them for final submission.

Larry

