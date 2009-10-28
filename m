Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35310 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZJ1TqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 15:46:16 -0400
Date: Wed, 28 Oct 2009 15:44:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH] rt2800pci.c : more ids
Message-ID: <20091028194406.GD2856@tuxdriver.com>
References: <4AD434B6.3090903@gmail.com> <4ADC3664.8050900@gmail.com> <200910191931.07361.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910191931.07361.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like those IDs were already added by Ivo...

On Mon, Oct 19, 2009 at 07:31:06PM +0200, Ivo van Doorn wrote:
> Hi,
> 
> I have merged your previous rt2800pci patch before sending it
> upstream. Please recheck and if required rebase your patch
> to the new version.
> 
> Thanks,
> 
> Ivo
> 
> On Monday 19 October 2009, Xose Vazquez Perez wrote:
> > On 10/13/2009 10:05 AM, Xose Vazquez Perez wrote:
> > 
> > > stolen from windows inf file(09/05/2009, 1.04.07.0000)
> > > 
> > > 0x1814, 0x3060
> > 
> > apply this one instead, 
> > got 0x1462,0x89a from linux driver(2009_0903_RT3090_Linux_STA_v2.2.0.1)
> > 
> > -thanks-
> > 
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > 
> 
> 
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
