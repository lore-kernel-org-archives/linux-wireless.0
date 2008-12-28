Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr04-10.mta.terra.com.br ([200.154.152.59]:55483 "EHLO
	sr04-10.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYL1GnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 01:43:22 -0500
Message-ID: <4957202A.5010706@unitednerds.org> (sfid-20081228_074357_867677_DBA513F6)
Date: Sun, 28 Dec 2008 04:43:54 -0200
From: Piter PUNK <piterpunk@unitednerds.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jason Self <jason.self@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Realtek wireless 8187se
References: <9EFEF18C-02C1-4E22-B712-9E5C582E4DEB@gmail.com> <20081216140222.GA3636@tuxdriver.com>
In-Reply-To: <20081216140222.GA3636@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Dec 15, 2008 at 06:41:01PM -0800, Jason Self wrote:
>> On Dec 15, 2008, at 5:26 PM, "John W. Linville" <linville@tuxdriver.com> 
>> wrote:
>>> I have acquired an MSI Wind equipped with this device, I have
>>> multiple variations of the vendor driver to support the hardware, and
>>> I have a datasheet the covers at least some of the hardware involved.
>>> I'm working on it...
>> Why not share your work?
> 
> What I have (which is barely anything) is on the "linville" branch
> of wireless-testing...

Hi John,

I am using that branch on mine Positivo Mobo White (MSI Wind OEM). It
loads the rtl8180 module, the wlan0 device appears but nothing more
happens. No scans, no associations, etc.

I'm really lost looking the code, and vendor code is very very different
of kernel code (at least to my eyes), isn't an easy job to "look vendor
code -> adapt code to kernel". What can I do to help? Any special
test case? Any log? Any tip to do the un-easy job?

Thanks!

Piter Punk

