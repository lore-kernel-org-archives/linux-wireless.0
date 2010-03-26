Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:35655 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752620Ab0CZAx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 20:53:57 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0189404835
	for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 09:53:55 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Date: Fri, 26 Mar 2010 09:53:48 +0900
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20100325054603.10697.48915.stgit@tt-desk> <201003260927.57491.br1@einfach.org> <20100326004431.GA2385@tux>
In-Reply-To: <20100326004431.GA2385@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003260953.49021.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 March 2010 09:44:31 Luis R. Rodriguez wrote:
> > as well, we all agree that there should be userland controls. the
> > questions is just about the interface to use.
> 
> ANI is specific to Atheros cards so debugfs would do it. If we want to
> have a more rigit API we could use a configfs entry for ath9k.

debugfs definetly is the wrong place! users might compile the module with 
debugging disabled (for performance reasons, e.g.).

are you sure about configfs? as far as i read about it it's for the dynamic 
creation of kernel objects, which is not what we are doing here. or did the 
rules change in the mean time?

bruno
