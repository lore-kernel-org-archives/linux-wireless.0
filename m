Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25073 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaELGtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 02:49:32 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Arik Nemtsov" <arik@wizery.com>,
	"Nemtsov, ArikX" <arikx.nemtsov@intel.com>
Subject: RE: [PATCH 1/7] cfg80211: don't set reg timeout for user-handled
 hint
Date: Mon, 12 May 2014 06:49:28 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DF0A87@HASMSX103.ger.corp.intel.com> (sfid-20140512_084935_896770_1F23B011)
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
	<1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
 <87egzz4hp7.fsf@purkki.adurom.net>
In-Reply-To: <87egzz4hp7.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
> 
> > From: Arik Nemtsov <arik@wizery.com>
> >
> > Otherwise every "indoor" setting by usermode will cause a regdomain
> reset.
> >
> > Change-Id: I3225325d9fb956174458d386d4dd0f4e069deb58
> > Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> All the patches in the series have the useless Change-Id tag.
> 

Yeah - I know - I thought I had removed them, but then I had to rebase the patches and they re-appeared. Anyway - I removed the hook from the directory, so that should be the last time I'll do that mistake. Thank you for pointing that out.
Johannes, do you want me to re-submit, or you'll remove them by yourself?
