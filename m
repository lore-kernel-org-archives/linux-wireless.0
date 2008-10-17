Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47763 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262AbYJQPpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 11:45:21 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: reinette chatre <reinette.chatre@intel.com>
To: myk.robinson@kingdomcomputer.info
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224248117.28593.3.camel@mobileOne>
References: <1224248117.28593.3.camel@mobileOne>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 08:45:14 -0700
Message-Id: <1224258314.11187.1.camel@rc-desk> (sfid-20081017_174607_128537_CB864542)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-17 at 07:55 -0500, Myk Robinson wrote:
> Hello-
> 
> Used your driver package in Ubuntu Hardy with no trouble at all. Testing
> the Intrepid beta now. Before today, using the compat-wireless driver
> for kernel 2.6.27, networkmanager showed all devices grayed out and
> iwlist scan would not work. Today's driver release has allowed me to
> connect, but still drops the connection with intel 2945abg. Also, it
> causes the touchpad to lose sync when the connection is dropped.
> 
> Here is a pastebin containing some dmesg info that might be helpful.
> 
> http://pastebin.com/f286ee42c
> 

The log shows some firmware errors. Could you please follow the steps on
http://intellinuxwireless.org/?n=fw_error_report to help us find the
cause of the problem?

Thanks

Reinette

