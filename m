Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:40452 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0ELPSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 11:18:44 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some accesspoint == hardlock
Date: Wed, 12 May 2010 17:18:41 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"NilsRadtkelkml@think-future.de" <NilsRadtkelkml@think-future.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20100503191756.GA3479@localhost> <201005111750.08533.borntraeger@de.ibm.com> <1273598493.2370.7891.camel@rchatre-DESK>
In-Reply-To: <1273598493.2370.7891.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005121718.41326.borntraeger@de.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 11 Mai 2010 19:21:33 schrieb reinette chatre:
> > de0f60ea94e132c858caa64a44b2012e1e8580b0
> > 8b9fce77737ae9983f61ec56cd53f52fb738b2c7
> > 
> > reverting both solves my hard lockup. I will try to isolate the "bad" patch
> > but this takes some more days since I wont be in the "hazardous environment"
> > this week.

Drat! Now I got a lockup with these two patches reverted. Dont know if that  was
the same bug.

> Thank you for digging into this. It will be very helpful it you can get
> us a trace of the crash - any chance that netconsole may work?

No success so far.



