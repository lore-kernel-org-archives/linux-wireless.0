Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13562 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcBNXwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 18:52:19 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>,
	"Peller, EliadX" <eliadx.peller@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the
 driver
Date: Sun, 14 Feb 2016 19:37:28 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA122F3@hasmsx107.ger.corp.intel.com> (sfid-20160215_005225_419652_1FFB0833)
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
 <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
 <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com>
 <1455477875.2564.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/14/2016 09:33 PM, Johannes Berg wrote:
> On Sun, 2016-02-14 at 19:34 +0200, Emmanuel Grumbach wrote:
>>  
>> Since the 3rd patch needs to be dropped anyway, let's route this one
>> through my tree as usual.
> It doesn't really have to be dropped, why? We can just make the same
> adjustment as for dvm in the patch.
>

But I am not sure I really want to play with drivers/staging/vt6656/rxtx.c
