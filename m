Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZAMQhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 11:37:35 -0500
Subject: Re: 802.11n status (iwlagn)
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Newton <nevion@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <496C3F37.4030808@gmail.com>
References: <496C3F37.4030808@gmail.com>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 08:39:29 -0800
Message-Id: <1231864769.20912.2.camel@rc-desk> (sfid-20090113_173739_495495_9286FD01)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-12 at 23:13 -0800, Jason Newton wrote:
> Hi all,
> 
> I've been searching around for a long time now and I find it difficult
> to understand what the current status of 802.11n is in linux as a whole
> and what it is with respect to iwlagn (4965 chipset specifically).  I
> want high-speed and reliable wireless :-)
> 
> Also, it would seem iwlagn n/ht still isn't working in 2.6.28?
> 
> To anyone who can clear all this up for me, I'd be much appreciative.
> 

802.11n does work in 2.6.28 - the speed is not there as changes in the
kernel caused breakage of TX aggregation. Other functionality of HT was
not affected. We recently started looking at getting TX aggregation
working again.

Reinette

