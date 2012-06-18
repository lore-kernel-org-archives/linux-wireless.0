Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2FRPi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 11:38:58 -0400
Date: Mon, 18 Jun 2012 17:38:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800: remove
 unsupported rf and chips
Message-ID: <20120618153852.GA3965@redhat.com> (sfid-20120618_173900_838749_8D892F79)
References: <1339882592-17680-1-git-send-email-xose.vazquez@gmail.com>
 <CAL1gcdNwChERae_B7S_TpZmi=Pi2MwUbDiwh+SFys8px96TFDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL1gcdNwChERae_B7S_TpZmi=Pi2MwUbDiwh+SFys8px96TFDA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2012 at 11:01:54AM +0200, Gertjan van Wingerde wrote:
> Hi Xose,
> 
> On Sat, Jun 16, 2012 at 11:36 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
> > removed, no support for:
> >
> > RF2853 2.4G/5G 3T3R
> > RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
> > RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
> >
> > RT3593
> > RT3883
> >
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> 
> I don't mind removing the RT chipset definitions, but I would like to
> retain the RF chipset definitions. Even
> though these definitions are not used in the code, the do represent
> values we could see from devices, so
> I consider the list to be documentation as well.

Perhaps we can comment them out, as compromise :-)

Stanislaw
