Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:36112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875AbbDMPFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 11:05:49 -0400
Date: Mon, 13 Apr 2015 11:05:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] iwlwifi: Move each system tracepoints to their own
 header
Message-ID: <20150413110546.32214082@gandalf.local.home> (sfid-20150413_170554_587502_D4B6983D)
In-Reply-To: <CANUX_P2EOwg_e8T7jJTQu5zH+Le+T5-y=DHom1LUmvMN47n42g@mail.gmail.com>
References: <20150406231357.2b8e452d@grimm.local.home>
	<1428389938.1841.1.camel@sipsolutions.net>
	<20150407102146.216cf90b@gandalf.local.home>
	<20150407121319.72d69ec5@gandalf.local.home>
	<1428479094.2809.3.camel@sipsolutions.net>
	<CANUX_P36HE+efTSvVYV5tYC01vNzoQKcLVECsH7QJXHPGirYdw@mail.gmail.com>
	<CANUX_P17eRZxGmi-RrYZPO1Acyfk_dvSbOh=XAsCe=7-Cs_Wsw@mail.gmail.com>
	<CANUX_P2EOwg_e8T7jJTQu5zH+Le+T5-y=DHom1LUmvMN47n42g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 13 Apr 2015 11:17:17 +0300
Emmanuel Grumbach <egrumbach@gmail.com> wrote:


> I overthought it. Stephen fixed the conflict correctly.
> 

Good, because I needed that change in my tree as other patches depended
on it.

Linus should be able to figure this out. I'll have to write up a bit
for him when I do my pull request, as my own branches have minor
conflicts.

Linus doesn't mind conflicts, but if you are aware of them, and already
did the merge fix, he likes to know about it, and pointers to the
conflict resolution is helpful, as he can compare what he did to what
we did.

I'll make note of the merge conflict resolution commit that Stephen did
in my pull request.

-- Steve
