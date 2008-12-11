Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYLKRNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:13:12 -0500
Subject: Re: iwlagn interrupt problem
From: reinette chatre <reinette.chatre@intel.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
	 <1228929548.18730.21.camel@rc-desk>
	 <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 09:14:15 -0800
Message-Id: <1229015655.18730.210.camel@rc-desk> (sfid-20081211_181316_576745_4B60602D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-11 at 05:48 -0800, Alexander E. Patrakov wrote:
> 2008/12/10 reinette chatre <reinette.chatre@intel.com>:
> > The unresponsiveness is due to a bug that was fixed recently. The
> > patches have been merged into wireless-testing repo and will be included
> > in 2.6.29. If you want to try
> > the individual patches, please try:
> > http://marc.info/?l=linux-wireless&m=122824886623698&w=2
> > http://marc.info/?l=linux-wireless&m=122849275528102&w=2
> 
> These individual patches don't apply to 2.6.27.6, so I installed
> today's compat-wireless-2.6, and it seems to work. Thanks!
> 
> OTOH, are these patches a material for backporting into -stable?

We are not planning to do so, but you are welcome to.

Reinette

