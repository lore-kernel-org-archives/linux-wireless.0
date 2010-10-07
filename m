Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33784 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0JGSaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:30:15 -0400
Received: by iwn9 with SMTP id 9so147626iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 11:30:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286475250.20974.22.camel@jlt3.sipsolutions.net>
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
 <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
 <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
 <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Oct 2010 11:29:53 -0700
Message-ID: <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 11:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
>> In case it helps, here is a dump of where the corrupted SKB was deleted.
>
> I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
> debugging into the mix could help you figure out if it's a DMA problem.

Ben, how much traffic are you RX'ing on these virtual interfaces?

  Luis
