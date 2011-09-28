Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54671 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1I1AOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 20:14:47 -0400
Received: by pzk1 with SMTP id 1so18877403pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 17:14:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U-=6UZfMvtv5Z77PcRbZCmXrbveM4N0mzcqXAR0QtTAQ@mail.gmail.com>
References: <CAMxespA2quGEuN3B0CE2SJGeRLr5vgtfqQYVQ5r5Oxtj-paj2w@mail.gmail.com>
 <CAPjQAd-=ihu5ULzuyUjGQD3DKe2Tpi749esOi9nb1c-dW=5nSQ@mail.gmail.com>
 <CAMxespDxUdm1Qx+GGYzzfJ+jdUVw_nmZDcyeRV2HqmB=0LhtDg@mail.gmail.com>
 <CAB=NE6USxp0rGPP2NFkThCFzpSccZ7WUF7AfxJ=3js5Ph5D82g@mail.gmail.com> <CAB=NE6U-=6UZfMvtv5Z77PcRbZCmXrbveM4N0mzcqXAR0QtTAQ@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 27 Sep 2011 17:14:27 -0700
Message-ID: <CAPjQAd-jdhPewBMT-9qmFPtuz58VL78+g2woy+yuk8fwAWaLTw@mail.gmail.com> (sfid-20110928_021450_729284_65EB67C7)
Subject: =?windows-1252?Q?Re=3A_Channel_type_negotiation_=96_HT_support_for_mesh?=
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Ashok Nagarajan <anagar6@uic.edu>, thomas <thomas@cozybit.com>,
	devel@lists.open80211s.org, Sidharth Thakur <sidthakur@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

On Tue, Sep 27, 2011 at 4:29 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> (...)
> A while back we had heard 802.11s support will *not* support
> aggregation, Javier, did the spec go out like that?

No it did not.  HT support (and aggregation) was a relatively late
addition to the draft and we never got to implement it.
But the spec assumes it is doable.  For A-MSDU aggregation, the Mesh
Control header should go on the first fragment.  I don't see anything
special required to support A-MPDU aggregation in mesh.

> Why was aggregation thought to not be possible with 802.11s?
> I can't see why right now.

Probably because when we had that conversation, HT support was not yet
specified in the draft?  Not sure.

> If we want to do comparable throughput tests for HT rates
> with Mesh we'd need to setup an AP with aggregation disabled, and the
> same WMM parameters.

OK

Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
