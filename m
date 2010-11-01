Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:55084 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0KAO3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 10:29:10 -0400
Subject: Re: [PATCH] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
From: David Woodhouse <dwmw2@infradead.org>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Nohee Ko <noheek@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>, greg@kroah.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101021170810.GA15357@broadcom.com>
References: <4CBE23F4.4020104@broadcom.com>
	 <20101019233520.GA12510@kroah.com>
	 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
	 <20101020004743.GB31965@kroah.com> <20101020005546.GL10832@broadcom.com>
	 <20101020010320.GA370@kroah.com>  <20101021170810.GA15357@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 10:28:59 -0400
Message-ID: <1288621739.26983.32.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-21 at 10:08 -0700, Henry Ptasinski wrote:
> Here's a patch to rename our firmware files in the linux-firmware repo.  I'll
> be sending a complimentary patch to Greg for staging-next-2.6 shortly.
> 
> The basename-apiversion-codeversion construction for firmware filenames is not
> used by most other firmware files, adds complexity, and is not providing any
> value.  Rename the firmware files using just basename-apiversion. 

Please use the '-M' option to git diff (or whatever you're using) to
make it detect renames -- the resulting patch would be a lot shorter.

And also please ensure the filenames listed in the WHENCE file are all
correct. You don't seem to have fixed those to reflect your changes. And
in fact I think the WHENCE file is *already* listing the bcm4329 files
in the wrong directory?

-- 
dwmw2

