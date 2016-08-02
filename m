Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbcHBOQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 10:16:17 -0400
Date: Tue, 2 Aug 2016 16:16:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	"mmarek@suse.com" <mmarek@suse.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160802141610.GJ3296@wotan.suse.de> (sfid-20160802_161647_328744_D0E0389F)
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com>
 <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
 <20160721080541.GB2658@redhat.com>
 <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com>
 <20160722221523.GM5537@wotan.suse.de>
 <874m738m02.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m738m02.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2016 at 11:10:22AM +0000, Valo, Kalle wrote:
> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> 
> > I was considering this as a future extension to the firmware API
> > through the new extensible firmware API, the sysdata API.
> 
> I think Linus mentioned this already, but I want to reiterate anyway.
> The name "sysdata" is horrible, I didn't have any idea what it means
> until I read your description. Please continue to use the term
> "firmware", anyone already know what it means.

We've gone well past using the firmware API for firmware though, if
we use it for 802.11 to replace CRDA for instance its really odd to
be calling it firmware. But sure... I will rebrand again to firmware...

  Luis
