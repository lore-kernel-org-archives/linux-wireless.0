Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59609 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0DSXVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 19:21:01 -0400
Received: by pwj9 with SMTP id 9so3830857pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 16:20:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271699405.14052.18189.camel@rchatre-DESK>
References: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
	<1271699405.14052.18189.camel@rchatre-DESK>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 19 Apr 2010 16:20:39 -0700
Message-ID: <i2v43e72e891004191620s15d3eb09m8fdc16f699b3285d@mail.gmail.com>
Subject: Re: iwlagn unexpected AddBA Req
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 19, 2010 at 10:50 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Thu, 2010-04-01 at 21:45 -0700, Luis R. Rodriguez wrote:
>> [  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>> [  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>> [  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>
>> I get a lof of these at spurious times against my WRT610N using
>> today's wireless-testing on iwlagn.
>
> If you still have this setup available, could you please try out the
> recent patch "mac80211: pass HT changes to driver when off
> channel" (http://thread.gmane.org/gmane.linux.kernel.wireless.general/49855 ) ?

Thanks Reinette, I've given my hardware to nbd.

  Luis
