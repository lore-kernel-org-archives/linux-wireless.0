Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54933 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbZAHQcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:32:25 -0500
Subject: Re: firmware for GSPI '8686 available
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org,
	Javier Cardona <javier@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
In-Reply-To: <45e8e6c40901061413n1a984e58n8e1643caa1fd481e@mail.gmail.com>
References: <45e8e6c40901061413n1a984e58n8e1643caa1fd481e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:31:13 -0500
Message-Id: <1231432273.21643.31.camel@localhost.localdomain> (sfid-20090108_173230_301601_EB6D9C96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-06 at 14:13 -0800, Andrey Yurovsky wrote:
> Marvell will make the 88W8686 GSPI firmware available for public
> download on their website in the next weeks.  In the meantime we've
> uploaded it to our website:
> http://cozybit.com/projects/gspi8686
> 
> Please note that you must accept Marvell's license before downloading the files.
> 
> We encourage you to use this firmware to test the patch set that Colin
> submitted on Jan 2nd.

I'm already pushing firmware for the following devices to Woodhouse's
linux-firmware tree:

mwl8k/fmimage_8687.fw
mwl8k/helper_8687.fw
libertas/gspi8686_v9.bin
libertas/sd8385.bin
libertas/sd8686_v9.bin
libertas/cf8385_helper.bin
libertas/sd8686_v8_helper.bin
libertas/cf8385.bin
libertas/usb8388_v9.bin
libertas/usb8388_v5.bin
libertas/sd8686_v8.bin
libertas/sd8686_v9_helper.bin
libertas/gspi8686_v9_helper.bin
libertas/sd8385_helper.bin

Pending one final sign-off from Manas, it'll be up and live.

Dan


