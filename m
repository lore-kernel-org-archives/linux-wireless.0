Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([207.7.131.186]:38176 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0CXP5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 11:57:36 -0400
Date: Wed, 24 Mar 2010 09:00:18 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: drago01 <drago01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Greg KH <greg@kroah.com>
Subject: Re: iwl6050 firmware?
Message-ID: <20100324160018.GN15308@hexapodia.org>
References: <20100323221350.GA20509@hexapodia.org> <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 24, 2010 at 09:15:53AM +0100, drago01 wrote:
> > It's been several months since iwl6050 support was merged to mainline,
> >
> >    commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
[snip]
> > but the firmware isn't yet in linux-firmware.git nor on
> 
> http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-6000-ucode-9.193.4.1.tgz
> ?
> 
> I don't think the 6050 need a separate firmware.

Yes, it does; it's asking for iwlwifi-6050-4.ucode on boot.  (I was
suprised too.)

-andy
