Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0JGSON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:14:13 -0400
Subject: Re: memory clobber in rx path, maybe related to ath9k.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAE0474.4090605@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com>
	 <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
	 <4CAB5F3D.9060201@candelatech.com>
	 <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
	 <4CAB627F.8020804@candelatech.com>
	 <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
	 <4CAB64AD.4080105@candelatech.com>
	 <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
	 <4CAB6B08.4050801@candelatech.com>  <4CAE0474.4090605@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 20:14:10 +0200
Message-ID: <1286475250.20974.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
> In case it helps, here is a dump of where the corrupted SKB was deleted.

I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
debugging into the mix could help you figure out if it's a DMA problem.

johannes

