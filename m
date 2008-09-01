Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYIAI1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 04:27:31 -0400
Subject: Re: frequent iwl3945 microcode errors
From: Zhu Yi <yi.zhu@intel.com>
To: Brian Crowley <brian@abtrafco.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2b4fb6bd0808300132m86c493eib19c9a2b29151ee9@mail.gmail.com>
References: <2b4fb6bd0808291719n6cb86dc3j307d63038b651a3@mail.gmail.com>
	 <2b4fb6bd0808300132m86c493eib19c9a2b29151ee9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 16:24:47 +0800
Message-Id: <1220257487.28282.100.camel@debian.sh.intel.com> (sfid-20080901_102752_932628_9A6C8C9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-08-30 at 10:32 +0200, Brian Crowley wrote:
> 
> Getting a bunch of microcode errors, every few minutes, sometimes
> leading to a hung system.  Seems to begin with psmouse failed resync..
> noticed resync problem happens when the network card is doing
> something like scanning or reestablishing link and am quite certain is
> related.. no resync failures when wireless card turned off. Here two
> iterations that ended up with a hang, ultimately degrading and forcing
> me to do a hard restart:

We have just released a new uCode for 3945 today. Maybe you want to try
it. Also, please load the module with debug=0x43fff when you attach the
dmesg. It dumps more uCode debug info.
http://intellinuxwireless.org/index.php?n=Downloads

Thanks,
-yi

