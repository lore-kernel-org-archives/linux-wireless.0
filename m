Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbbLCPcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 10:32:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ben Ami\, Golan" <golan.ben.ami@intel.com>
Subject: Re: [PATCH 24/41] iwlwifi: mvm: move fw-dbg code to separate file
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
	<1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
	<87r3j6gfws.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E90714D@hasmsx107.ger.corp.intel.com>
	<CANUX_P0Y5nDACtND_WaQfXBQq2AyLbxxdOX-S5NfQODzdiaK3g@mail.gmail.com>
Date: Thu, 03 Dec 2015 17:32:09 +0200
In-Reply-To: <CANUX_P0Y5nDACtND_WaQfXBQq2AyLbxxdOX-S5NfQODzdiaK3g@mail.gmail.com>
	(Emmanuel Grumbach's message of "Tue, 1 Dec 2015 21:26:20 +0200")
Message-ID: <87h9jzeefa.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_163218_805498_5F5B178F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

>> Indeed... Thanks for catching this...
>> Will re-spin...
>
>  I pushed -f the tree with the same tag. Should be fine now. Thanks again.

I would prefer that you create a new tag in cases like this. Just to
make sure that I don't accidentally pull the old tag.

-- 
Kalle Valo
