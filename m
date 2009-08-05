Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:9436 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZHEFyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:54:14 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1334533fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 22:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249451506.6902.2.camel@johannes.local>
References: <1249056817.20593.1.camel@maxim-laptop> <1249056896.20593.3.camel@maxim-laptop>
	<1249438947.3094.30.camel@localhost.localdomain> <1249450153.6083.4.camel@maxim-laptop>
	<1249450416.4168.22.camel@johannes.local> <69e28c910908042250n1e0bf9c6v20b6301db9e3286b@mail.gmail.com>
	<1249451506.6902.2.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 5 Aug 2009 07:53:54 +0200
Message-ID: <69e28c910908042253t67e5aa93j1db74dfe187a9bd1@mail.gmail.com>
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/5 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-08-05 at 07:50 +0200, Gábor Stefanik wrote:
>
>> My €0.02 (€ because I'm European :) ): Shouldn't probe requests be NO_ACK?
>
> Of course not. What makes you think so?
>
> johannes
>
>

It just feels illogical to me that the AP essentially has to respond
to probes twice (it sends an ACK, then a probe response) - but if that
is what the 802.11 spec calls for, then its fine.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
