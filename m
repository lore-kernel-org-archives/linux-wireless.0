Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout07.sul.t-online.de ([194.25.134.83]:52025 "EHLO
	mailout07.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYAZROU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 12:14:20 -0500
Message-ID: <479B6A5E.4070407@t-online.de> (sfid-20080126_171443_225385_B34411A5)
Date: Sat, 26 Jan 2008 18:14:06 +0100
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
> Also, could you please open a bug in our bug tracker
> (http://www.bughost.org/bugzilla/) - this will make it easier to keep
> all info together and get the right people to take a look at it.
> 

moving to bug tracker, see http://bughost.org/bugzilla/show_bug.cgi?id=1577 .
The requested debug output has been posted there, too.


Regards

Harri

