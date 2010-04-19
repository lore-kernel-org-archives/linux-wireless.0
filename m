Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0DSRuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:50:06 -0400
Subject: Re: iwlagn unexpected AddBA Req
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
References: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 10:50:05 -0700
Message-ID: <1271699405.14052.18189.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-01 at 21:45 -0700, Luis R. Rodriguez wrote:
> [  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
> [  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
> [  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
> 
> I get a lof of these at spurious times against my WRT610N using
> today's wireless-testing on iwlagn.

If you still have this setup available, could you please try out the
recent patch "mac80211: pass HT changes to driver when off
channel" (http://thread.gmane.org/gmane.linux.kernel.wireless.general/49855 ) ?

Thank you

Reinette

