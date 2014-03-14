Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48887 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaCNTaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:30:14 -0400
Date: Fri, 14 Mar 2014 15:23:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: fariyaf@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 00/11] rsi: Adding RS9113 wireless driver.
Message-ID: <20140314192341.GE20339@tuxdriver.com> (sfid-20140314_203018_914600_2005E6E8)
References: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2014 at 08:56:28PM +0530, fariyaf@gmail.com wrote:
> From: Fariya Fatima <fariyaf@gmail.com>
> 
> This series of patches adds Redpine Signals wireless driver.
> 
> Fariya Fatima (11):
>   Adding RS9113 driver header files
>   Adding remaining header files
>   Adding core and main files.
>   Writing packets to device and debugfs.
>   MAC80211 callbacks to driver.
>   MAC80211 callbacks and management functions internal to device.
>   Management functions internal to the device.
>   USB functionality
>   SDIO functionality.
>   Remaining SDIO functionality.
>   Makefile and Kconfig

I have applied these to wireless-next, after squashing them into a
single commit.

In the future, please put your "Signed-off-by" lines _after_ the
changelog comments...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
