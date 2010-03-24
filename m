Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:35235 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab0CXI3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 04:29:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100323221350.GA20509@hexapodia.org>
References: <20100323221350.GA20509@hexapodia.org>
Date: Wed, 24 Mar 2010 09:15:53 +0100
Message-ID: <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com>
Subject: Re: iwl6050 firmware?
From: drago01 <drago01@gmail.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:13 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> Hi,
>
> It's been several months since iwl6050 support was merged to mainline,
>
>    commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
>    Author: Jay Sternberg <jay.e.sternberg@linux.intel.com>
>    Date:   Mon Jan 19 15:30:34 2009 -0800
>
>        iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
>
> and hardware is shipping,
>
> 02:00.0 Network controller: Intel Corporation WiMAX/WiFi Link 6050 Series (rev 35)
>
> but the firmware isn't yet in linux-firmware.git nor on
> intellinuxwireless.org.
>
> Any ETA on a release?

http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-6000-ucode-9.193.4.1.tgz
?

I don't think the 6050 need a separate firmware.
