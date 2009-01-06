Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41314 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZAFUal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:30:41 -0500
Date: Tue, 6 Jan 2009 15:29:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Piter PUNK <piterpunk@unitednerds.org>
Cc: Jason Self <jason.self@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Realtek wireless 8187se
Message-ID: <20090106202936.GF3544@tuxdriver.com> (sfid-20090106_213049_147046_66B8EFC3)
References: <9EFEF18C-02C1-4E22-B712-9E5C582E4DEB@gmail.com> <20081216140222.GA3636@tuxdriver.com> <4957202A.5010706@unitednerds.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4957202A.5010706@unitednerds.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 04:43:54AM -0200, Piter PUNK wrote:
> John W. Linville wrote:
>> On Mon, Dec 15, 2008 at 06:41:01PM -0800, Jason Self wrote:
>>> On Dec 15, 2008, at 5:26 PM, "John W. Linville" 
>>> <linville@tuxdriver.com> wrote:
>>>> I have acquired an MSI Wind equipped with this device, I have
>>>> multiple variations of the vendor driver to support the hardware, and
>>>> I have a datasheet the covers at least some of the hardware involved.
>>>> I'm working on it...
>>> Why not share your work?
>>
>> What I have (which is barely anything) is on the "linville" branch
>> of wireless-testing...
>
> Hi John,
>
> I am using that branch on mine Positivo Mobo White (MSI Wind OEM). It
> loads the rtl8180 module, the wlan0 device appears but nothing more
> happens. No scans, no associations, etc.

There really is nothing there to activate the device, just some
infrastructure bits.

> I'm really lost looking the code, and vendor code is very very different
> of kernel code (at least to my eyes), isn't an easy job to "look vendor
> code -> adapt code to kernel". What can I do to help? Any special
> test case? Any log? Any tip to do the un-easy job?

Now that we are done with the holidays, hopefully I can make some
progress on this soon.  Until then, there isn't much for you to do...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
