Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout07.sul.t-online.de ([194.25.134.83]:52459 "EHLO
	mailout07.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYAZOyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 09:54:49 -0500
Message-ID: <479B49A6.1020902@t-online.de> (sfid-20080126_145455_659803_F8D16AF3)
Date: Sat, 26 Jan 2008 15:54:30 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	dhazelton@enter.net, "Cahill, Ben M" <ben.m.cahill@intel.com>
Subject: Re: 2.6.24-rc8: iwl3945 gets stuck
References: <4797994C.1090900@t-online.de> <D936D925018D154694D8A362EEB08920037FFC19@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB08920037FFC19@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette wrote:
> 
> Very strange. Would it be possible to load the module with
> "debug=0x43fff"? This will capture a detailed event log and error log
> from uCode, so we can see what caused the uCode error.
> 

I will try. Is there some way to turn debug on and off after
the module has been loaded, e.g. by running

	echo 0x43fff >/proc/some/fancy/path

?


Regards

Harri

