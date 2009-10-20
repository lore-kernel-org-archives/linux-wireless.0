Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZJTRQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 13:16:07 -0400
Subject: Re: Wrong BSSID generation in IBSS mode with ath5k
From: reinette chatre <reinette.chatre@intel.com>
To: Karol =?UTF-8?Q?Pucy=C5=84ski?= <kpucynski@7bulls.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1256052469.6550.7.camel@kpucynski-laptop>
References: <1256052469.6550.7.camel@kpucynski-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Oct 2009 10:16:05 -0700
Message-Id: <1256058965.21134.1409.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-20 at 08:27 -0700, Karol Pucyński wrote:
> I have IBSS network (based on ath5k cards).
> With the same channel/essid set cards often can't "negotiate" the 
> same BSSID. Two nodes beside each other both create new IBSS networks
> and they are not trying to merge.
> Workaround: forcing BSSID with iw does work.
> 
> Do you know what can be the reason of this problem?
> 
> Tested on 2.6.31 kernel. May be related to my earlier problem 'ath5k
> IBSS fixed rate'...

Are you using compat-wireless? If not, then ignore this email.

If you are using the latest wireless bits using compat-wireless then you
may have run into this issue
http://thread.gmane.org/gmane.linux.kernel.wireless.general/41129

Reinette


