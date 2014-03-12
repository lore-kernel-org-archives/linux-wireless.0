Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:39170 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751412AbaCLOL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 10:11:28 -0400
Message-ID: <1394633481.28839.54.camel@joe-AO722> (sfid-20140312_151131_846248_63AFE922)
Subject: Re: [PATCH 2/6] ath6kl: use braces on both arms of if statement
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Jones Desougi <jones.desougi@27m.se>, ath6kl@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Wed, 12 Mar 2014 07:11:21 -0700
In-Reply-To: <87iorjg5ok.fsf@kamboji.qca.qualcomm.com>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065717.10793.76274.stgit@x230>
	 <1394401348.6972.50.camel@joe-AO722> <53201F25.30200@27m.se>
	 <87iorjg5ok.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-12 at 10:52 +0200, Kalle Valo wrote:
> Jones Desougi <jones.desougi@27m.se> writes:
> > That inverts the meaning of the condition though.
> > On 03/09/2014 10:42 PM, Joe Perches wrote:
> > ...
> >> -	if (bss == NULL) {
> > ...
> >> -	} else
> >> +	if (!bss) {
> >         if (bss) {
> Yeah, that was buggy. Thanks for pointing it out.

Yes, I stuffed that one up.
And Jones, thanks for noticing.


