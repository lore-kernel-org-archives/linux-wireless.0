Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22866 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKTWlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 17:41:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 14:41:07 -0800
Date: Thu, 20 Nov 2008 14:41:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "Xu, Martin" <martin.xu@intel.com>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Wang, Yong Y" <yong.y.wang@intel.com>,
	Vikram Kandukuri <Vikram.Kandukuri@Atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@Atheros.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts
	per second at idle
Message-ID: <20081120224103.GD5899@tesla> (sfid-20081120_234113_380375_CA28991C)
References: <bug-11749-13098@http.bugzilla.kernel.org/> <20081013150525.884BC108058@picon.linux-foundation.org> <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com> <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com> <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com> <20081117133737.GA16412@hash.localnet> <9F0C1DB20AFA954FA1DA05309350433D41183AB4@pdsmsx503.ccr.corp.intel.com> <b6c5339f0811201401u18aa9e32nef8433c1aaaf8936@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0811201401u18aa9e32nef8433c1aaaf8936@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 02:01:19PM -0800, Bob Copeland wrote:
> Hi Martin,
> 
> > From: Martin Xu <martin.xu@intel.com>
> > Subject: disable beacon filter when station is not associated with any AP.
> >
> > Ath5k driver has too many interrupts per second at idle
> > http://bugzilla.kernel.org/show_bug.cgi?id=11749
> >
> > Signed-off-by: Martin Xu <martin.xu@intel.com>
> 
> Thanks for the cleanups.  I don't have any objections to the patch.
> Anyone else want to weigh in?

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Please close the bug report too.

  Luis
