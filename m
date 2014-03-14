Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaCNTaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:30:14 -0400
Date: Fri, 14 Mar 2014 15:26:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: fariyaf@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 00/11] rsi: Adding RS9113 wireless driver.
Message-ID: <20140314192604.GF20339@tuxdriver.com> (sfid-20140314_203021_753716_77D71B63)
References: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
 <1394823891.5829.14.camel@dcbw.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394823891.5829.14.camel@dcbw.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2014 at 02:04:51PM -0500, Dan Williams wrote:
> On Mon, 2014-03-10 at 20:56 +0530, fariyaf@gmail.com wrote:
> > From: Fariya Fatima <fariyaf@gmail.com>
> > 
> > This series of patches adds Redpine Signals wireless driver.
> 
> Looking much better, good work.
> 
> One last comment; there are a couple functions (rsi_device_init,
> rsi_host_intf_write_pkt) that are defined multiple times, once in the
> USB code and once in the SDIO code.  These need to be renamed, otherwise
> you will not be able to load the USB and the SDIO modules at the same
> time.
> 
> I would suggest making all the functions in rsi_usb.h start with
> "rsi_usb" if they don't already, and have functions in rsi_sdio.h start
> with "rsi_sdio" if they don't already.

Good thing I haven't pushed yet... :-)

Please make the changes Dan suggests and resubmit...thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
