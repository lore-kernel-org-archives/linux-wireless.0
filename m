Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64936 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1GWDID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 23:08:03 -0400
Received: by gyh3 with SMTP id 3so1609928gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 20:08:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311341808.5579.51.camel@wwguy-huron>
References: <CACVXFVNe=4MEyv=9di7Yh+E-mifdMT77PxmBxFBM0PWvHwVY9g@mail.gmail.com>
	<1311341808.5579.51.camel@wwguy-huron>
Date: Sat, 23 Jul 2011 11:08:02 +0800
Message-ID: <CACVXFVMC3db=d+DSW1uSmQCGdSZThJfDj-QSyp8QS5B1OMP47A@mail.gmail.com> (sfid-20110723_050829_435380_CE13878B)
Subject: Re: 3.0: iwlagn: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000004
From: Ming Lei <tom.leiming@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jul 22, 2011 at 9:36 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Lei,
>
> On Fri, 2011-07-22 at 03:54 -0700, Ming Lei wrote:
>> Hi,
>>
>> The bug is triggered after I run 'pm-suspend' to do system sleep.
>>
>> See attachment.
>
> Could you try this patch in mac80211 from wireless-next-2.6 tree
>
>
> commit 94f9b97be5b3bf67392e43fb7f567721b09142c2
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Jul 14 16:48:54 2011 +0200
>
>    mac80211: be more careful in suspend/resume

Yes, this patch does fix the bug.


thanks,
-- 
Ming Lei
