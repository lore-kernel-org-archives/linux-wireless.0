Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0CSJjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 05:39:23 -0400
Date: Fri, 19 Mar 2010 10:37:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: sedat.dilek@gmail.com
Cc: Adel Gadllah <adel.gadllah@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH] iwlwifi: Silence tfds_in_queue message
Message-ID: <20100319093721.GA21886@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com> <1268758859.2446.595.camel@rchatre-DESK> <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com> <6cf6b73e1003180811w5c577652i308b4d4e06b6011a@mail.gmail.com> <2d0a357f1003190222x27dcf885k9eff60c65492fc07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2d0a357f1003190222x27dcf885k9eff60c65492fc07@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 10:22:14AM +0100, Sedat Dilek wrote:
> only to clarify:
> There is no need for "iwlwifi: Silence tfds_in_queue message" patch
> from wireless-2.6 GIT?
>
> I mean "[2.6.32] iwlwifi: fix nfreed--" is enough for solving the
> mentionned problem?

Yes. That was confirmed by Adel.

Cheers
Stanislaw
