Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:25531 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYAZP3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 10:29:51 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1114032rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 07:29:48 -0800 (PST)
Date: Sun, 27 Jan 2008 00:29:42 +0900
From: Joonwoo Park <joonwpark81@gmail.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	dhazelton@enter.net, "Cahill, Ben M" <ben.m.cahill@intel.com>
Subject: Re: 2.6.24-rc8: iwl3945 gets stuck
Message-ID: <20080126152942.GA5914@joonwpark-laptop> (sfid-20080126_153011_212827_829CFA37)
References: <4797994C.1090900@t-online.de> <D936D925018D154694D8A362EEB08920037FFC19@orsmsx416.amr.corp.intel.com> <479B49A6.1020902@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <479B49A6.1020902@t-online.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 26, 2008 at 03:54:30PM +0100, Harald Dunkel wrote:
>
> I will try. Is there some way to turn debug on and off after
> the module has been loaded, e.g. by running
>
> 	echo 0x43fff >/proc/some/fancy/path
>
> ?

please build kernel with CONFIG_IWLWIFI_DEBUG=y
mount sysfs on /sys
echo 0x43fff > /sys/bus/pci/drivers/iwl3945/debug_level

Thanks,
Joonwoo
