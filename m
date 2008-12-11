Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:44041 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbYLKNsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 08:48:54 -0500
Message-ID: <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com> (sfid-20081211_144901_601922_AD8212B2)
Date: Thu, 11 Dec 2008 18:48:52 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "reinette chatre" <reinette.chatre@intel.com>
Subject: Re: iwlagn interrupt problem
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1228929548.18730.21.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
	 <1228929548.18730.21.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/10 reinette chatre <reinette.chatre@intel.com>:
> The messages you refer to are printed because a user space app
> (wpa_supplicant or network manager) brings the wireless interface down
> and up. Interrupts are disabled when interface is brought down and
> reenabled when interface is brought up.

OK.

> The unresponsiveness is due to a bug that was fixed recently. The
> patches have been merged into wireless-testing repo and will be included
> in 2.6.29. If you want to try
> the individual patches, please try:
> http://marc.info/?l=linux-wireless&m=122824886623698&w=2
> http://marc.info/?l=linux-wireless&m=122849275528102&w=2

These individual patches don't apply to 2.6.27.6, so I installed
today's compat-wireless-2.6, and it seems to work. Thanks!

OTOH, are these patches a material for backporting into -stable?

-- 
Alexander E. Patrakov
